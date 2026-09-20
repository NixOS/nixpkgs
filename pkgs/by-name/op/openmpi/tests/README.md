Run the floating-point regression on the installed package's HOST:

```sh
bash run-floating.sh /nix/store/...-openmpi-dev /nix/store/...-openmpi
```

Additional arguments are passed to `mpiexec`. `MPI_TEST_RANKS` defaults to two;
one rank still checks local reductions, packing and communication with itself.
For a cross-built package, copy its outputs and compiler closure to HOST first.
The harness uses the installed `mpicc` and `mpifort`, so it also checks their
runtime compiler selection. It creates and removes only its temporary binaries.

The C control preserves `MPI_LONG_DOUBLE` and `MPI_C_LONG_DOUBLE_COMPLEX`.
The Fortran test uses `mpi_f08`, `MPI_REAL16` and `MPI_COMPLEX32`, with values
requiring more than x87's 64 significant bits. Both cover local and collective
SUM/PROD, real MIN/MAX, send/receive, native pack/unpack and external32.
External32 checks canonical IEEE binary128 bytes and separately unpacks those
bytes: a broken pack/unpack pair cannot pass merely by undoing its own mistake.

The Fortran test requires a compiler supporting IEEE binary128; compilation
failure is not treated as a successful test. These programs cover local CPU
datatypes, not CUDA buffers, RDMA, inter-node transport or mixed-version ranks.

`bash quad-configure.sh APPLIED_SOURCE/config/ompi_fortran_check_real16_c_equiv.m4`
checks the actual Autoconf macro's `_Quad` fallback using controlled availability
and representation answers. It needs Autoconf and a working C compiler. The
upstream inverted availability guard fails this test; the corrected guard enters
the probe and preserves both its matching and nonmatching outcomes; unavailable
types never reach that probe. This is a
configure branch control, not a build or ABI validation with an Intel compiler.

`python3 cuda-diagnostic-formats.py APPLIED_SOURCE` compiles the CUDA help
messages with the argument types used by their callers, strict printf-format
checking and AddressSanitizer/UndefinedBehaviorSanitizer. It checks a byte count
larger than 32 bits and the registration-cache field supplied only during init.
Use `--expect-invalid` against the unpatched source for the negative control;
use `--cc` to select a compiler supporting those sanitizers. This tests diagnostic
formatting, not CUDA transfers or the reason a driver registration failed.
