program floating_fortran
  use mpi_f08
  use iso_c_binding, only: c_int8_t
  implicit none
  integer, parameter :: q = selected_real_kind(33, 4931)
  integer :: rank, ranks, ierr, failures = 0, total, op, r, position, packed_size
  integer(kind=MPI_ADDRESS_KIND) :: external_size, external_position
  type(MPI_Op) :: operations(4)
  real(q) :: epsilon, a, b, expected, real_input(3), real_output(3)
  complex(q) :: ca, cb, complex_expected, complex_input(3), complex_output(3)
  integer(c_int8_t) :: packed(256), canonical(32)

  call MPI_Init(ierr)
  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, ranks, ierr)
  call MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN, ierr)
  call MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN, ierr)
  operations = [MPI_SUM, MPI_PROD, MPI_MIN, MPI_MAX]
  ! This term survives binary128 but not x87 long double or binary64.
  epsilon = 2.0_q**(-100)
  do op = 1, 4
    a = 1.0_q + epsilon
    b = 1.0_q + 2.0_q * epsilon
    select case (op)
    case (1)
      expected = a + b
    case (2)
      expected = a * b
    case (3)
      expected = min(a, b)
    case (4)
      expected = max(a, b)
    end select
    call MPI_Reduce_local(a, b, 1, MPI_REAL16, operations(op), ierr)
    call check(ierr == MPI_SUCCESS, 'REAL16 reduce_local')
    call check(b == expected, 'REAL16 reduce_local value')
    a = real(rank + 1, q) + epsilon
    expected = 0
    if (op == 2) expected = 1
    do r = 0, ranks - 1
      if (op == 1) expected = expected + real(r + 1, q) + epsilon
      if (op == 2) expected = expected * (real(r + 1, q) + epsilon)
    end do
    if (op == 3) expected = 1.0_q + epsilon
    if (op == 4) expected = real(ranks, q) + epsilon
    call MPI_Allreduce(a, b, 1, MPI_REAL16, operations(op), MPI_COMM_WORLD, ierr)
    call check(ierr == MPI_SUCCESS, 'REAL16 allreduce')
    call check(b == expected, 'REAL16 allreduce value')
  end do
  do op = 1, 2
    ca = cmplx(1.0_q + epsilon, 2.0_q, q)
    cb = cmplx(3.0_q + epsilon, -4.0_q, q)
    if (op == 1) complex_expected = ca + cb
    if (op == 2) complex_expected = ca * cb
    call MPI_Reduce_local(ca, cb, 1, MPI_COMPLEX32, operations(op), ierr)
    call check(ierr == MPI_SUCCESS, 'COMPLEX32 reduce_local')
    call check(cb == complex_expected, 'COMPLEX32 reduce_local value')
    ca = cmplx(real(rank + 1, q) + epsilon, 2.0_q, q)
    complex_expected = 0
    if (op == 2) complex_expected = 1
    do r = 0, ranks - 1
      if (op == 1) complex_expected = complex_expected + cmplx(real(r + 1, q) + epsilon, 2.0_q, q)
      if (op == 2) complex_expected = complex_expected * cmplx(real(r + 1, q) + epsilon, 2.0_q, q)
    end do
    call MPI_Allreduce(ca, cb, 1, MPI_COMPLEX32, operations(op), MPI_COMM_WORLD, ierr)
    call check(ierr == MPI_SUCCESS, 'COMPLEX32 allreduce')
    call check(cb == complex_expected, 'COMPLEX32 allreduce value')
  end do

  real_input = [1.0_q + epsilon, -2.25_q, 0.0_q]
  real_output = 0
  call MPI_Sendrecv(real_input, 3, MPI_REAL16, modulo(rank + 1, ranks), 8, &
                    real_output, 3, MPI_REAL16, modulo(rank - 1, ranks), 8, &
                    MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
  call check(ierr == MPI_SUCCESS, 'REAL16 sendrecv')
  call check(all(real_output == real_input), 'REAL16 sendrecv values')
  position = 0
  call MPI_Pack(real_input, 3, MPI_REAL16, packed, size(packed), position, MPI_COMM_WORLD, ierr)
  call check(ierr == MPI_SUCCESS, 'REAL16 pack')
  packed_size = position
  position = 0
  real_output = 0
  call MPI_Unpack(packed, packed_size, position, real_output, 3, MPI_REAL16, MPI_COMM_WORLD, ierr)
  call check(ierr == MPI_SUCCESS, 'REAL16 unpack')
  call check(all(real_output == real_input), 'REAL16 unpack values')

  complex_input = [cmplx(1.0_q + epsilon, -2.25_q, q), cmplx(3.0_q, 4.0_q, q), cmplx(0.0_q, 0.0_q, q)]
  complex_output = 0
  call MPI_Sendrecv(complex_input, 3, MPI_COMPLEX32, modulo(rank + 1, ranks), 9, &
                    complex_output, 3, MPI_COMPLEX32, modulo(rank - 1, ranks), 9, &
                    MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
  call check(ierr == MPI_SUCCESS, 'COMPLEX32 sendrecv')
  call check(all(complex_output == complex_input), 'COMPLEX32 sendrecv values')
  position = 0
  call MPI_Pack(complex_input, 3, MPI_COMPLEX32, packed, size(packed), position, MPI_COMM_WORLD, ierr)
  call check(ierr == MPI_SUCCESS, 'COMPLEX32 pack')
  packed_size = position
  position = 0
  complex_output = 0
  call MPI_Unpack(packed, packed_size, position, complex_output, 3, MPI_COMPLEX32, MPI_COMM_WORLD, ierr)
  call check(ierr == MPI_SUCCESS, 'COMPLEX32 unpack')
  call check(all(complex_output == complex_input), 'COMPLEX32 unpack values')

  ! Independent canonical IEEE binary128 values: 1.5 and -2.25.
  canonical = 0
  canonical(1:3) = [63_c_int8_t, -1_c_int8_t, int(z'80', c_int8_t)]
  canonical(17:19) = [-64_c_int8_t, 0_c_int8_t, 32_c_int8_t]
  a = 1.5_q
  b = 0
  packed = 0
  external_position = 0
  call MPI_Pack_external_size('external32', 1, MPI_REAL16, external_size, ierr)
  call check(ierr == MPI_SUCCESS .and. external_size == 16, 'REAL16 external32 size')
  call MPI_Pack_external('external32', a, 1, MPI_REAL16, packed, &
                         int(size(packed), MPI_ADDRESS_KIND), external_position, ierr)
  call check(ierr == MPI_SUCCESS .and. external_position == 16, 'REAL16 external32 pack')
  call check(all(packed(1:16) == canonical(1:16)), 'REAL16 external32 canonical bytes')
  external_position = 0
  call MPI_Unpack_external('external32', canonical, 16_MPI_ADDRESS_KIND, external_position, b, 1, MPI_REAL16, ierr)
  call check(ierr == MPI_SUCCESS .and. b == a, 'REAL16 external32 canonical value')
  ca = cmplx(1.5_q, -2.25_q, q)
  cb = 0
  packed = 0
  external_position = 0
  call MPI_Pack_external_size('external32', 1, MPI_COMPLEX32, external_size, ierr)
  call check(ierr == MPI_SUCCESS .and. external_size == 32, 'COMPLEX32 external32 size')
  call MPI_Pack_external('external32', ca, 1, MPI_COMPLEX32, packed, &
                         int(size(packed), MPI_ADDRESS_KIND), external_position, ierr)
  call check(ierr == MPI_SUCCESS .and. external_position == 32, 'COMPLEX32 external32 pack')
  call check(all(packed(1:32) == canonical), 'COMPLEX32 external32 canonical bytes')
  external_position = 0
  call MPI_Unpack_external('external32', canonical, 32_MPI_ADDRESS_KIND, external_position, cb, 1, MPI_COMPLEX32, ierr)
  call check(ierr == MPI_SUCCESS .and. cb == ca, 'COMPLEX32 external32 canonical value')

  call MPI_Allreduce(failures, total, 1, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD, ierr)
  if (rank == 0) print *, 'Fortran floating ABI: kind=', q, ' digits=', digits(a), ' ranks=', ranks, ' failures=', total
  call MPI_Finalize(ierr)
  if (total /= 0) stop 1
contains
  subroutine check(condition, name)
    logical, intent(in) :: condition
    character(*), intent(in) :: name
    if (.not. condition) then
      print *, 'rank', rank, ': FAIL ', name
      failures = failures + 1
    end if
  end subroutine
end program
