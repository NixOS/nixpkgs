#include <complex.h>
#include <float.h>
#include <mpi.h>
#include <stdio.h>
#include <string.h>

static int failures, rank, ranks;

static void check(int condition, const char *name)
{
    if (!condition) {
        fprintf(stderr, "rank %d: FAIL %s\n", rank, name);
        ++failures;
    }
}

static void external(const void *input, void *output, MPI_Datatype type, int complex_value)
{
    /* external32 is IEEE binary128, including when local long double is x87. */
    unsigned char expected[32] = {0x3f, 0xff, 0x80}; /* 1.5 */
    unsigned char bytes[128] = {0};
    MPI_Aint position = 0, size = 0;
    if (complex_value) { /* imaginary part -2.25 */
        expected[16] = 0xc0;
        expected[17] = 0x00;
        expected[18] = 0x20;
    }
    check(MPI_Pack_external_size("external32", 1, type, &size) == MPI_SUCCESS,
          "C external32 size call");
    check(size == (complex_value ? 32 : 16), "C external32 size");
    if (size != (complex_value ? 32 : 16)) return;
    check(MPI_Pack_external("external32", input, 1, type, bytes, sizeof bytes,
                            &position) == MPI_SUCCESS, "C external32 pack");
    check(position == size, "C external32 packed position");
    check(memcmp(bytes, expected, (size_t)size) == 0, "C external32 canonical bytes");
    /* Unpack canonical bytes independently; a broken round trip can cancel. */
    position = 0;
    check(MPI_Unpack_external("external32", expected, size, &position, output, 1,
                              type) == MPI_SUCCESS, "C external32 unpack canonical bytes");
    check(position == size, "C external32 unpacked position");
}

#define TRANSPORT(TYPE, MPI_TYPE, VALUES, LABEL) do { \
    const TYPE *input = VALUES; TYPE output[3] = {0}; \
    unsigned char packed[256] = {0}; \
    int position = 0, packed_size; \
    check(MPI_Sendrecv(input, 3, MPI_TYPE, (rank + 1) % ranks, 7, output, 3, MPI_TYPE, \
                      (rank + ranks - 1) % ranks, 7, MPI_COMM_WORLD, MPI_STATUS_IGNORE) \
          == MPI_SUCCESS, LABEL " sendrecv"); \
    for (int i = 0; i < 3; ++i) check(output[i] == input[i], LABEL " sendrecv values"); \
    check(MPI_Pack(input, 3, MPI_TYPE, packed, sizeof packed, &position, MPI_COMM_WORLD) \
          == MPI_SUCCESS, LABEL " pack"); \
    packed_size = position; position = 0; memset(output, 0, sizeof output); \
    check(MPI_Unpack(packed, packed_size, &position, output, 3, MPI_TYPE, MPI_COMM_WORLD) \
          == MPI_SUCCESS, LABEL " unpack"); \
    for (int i = 0; i < 3; ++i) check(output[i] == input[i], LABEL " unpack values"); \
} while (0)

int main(int argc, char **argv)
{
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &ranks);
    MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);
    MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN);

    MPI_Op operations[] = {MPI_SUM, MPI_PROD, MPI_MIN, MPI_MAX};
    const long double local_expected[] = {3.75L, 3.375L, 1.5L, 2.25L};
    for (int op = 0; op < 4; ++op) {
        long double input = 1.5L, output = 2.25L, expected = op == 1 ? 1 : 0;
        check(MPI_Reduce_local(&input, &output, 1, MPI_LONG_DOUBLE, operations[op])
              == MPI_SUCCESS, "C long double reduce_local");
        check(output == local_expected[op], "C long double reduce_local value");
        input += rank;
        for (int r = 0; r < ranks; ++r) {
            if (op == 0) expected += 1.5L + r;
            if (op == 1) expected *= 1.5L + r;
        }
        if (op == 2) expected = 1.5L;
        if (op == 3) expected = 0.5L + ranks;
        check(MPI_Allreduce(&input, &output, 1, MPI_LONG_DOUBLE, operations[op],
                             MPI_COMM_WORLD) == MPI_SUCCESS, "C long double allreduce");
        check(output == expected, "C long double allreduce value");
    }
    for (int op = 0; op < 2; ++op) {
        long double complex input = 1.5L + 2.0Li, output = 2.25L - 0.5Li;
        long double complex expected = op ? input * output : input + output;
        check(MPI_Reduce_local(&input, &output, 1, MPI_C_LONG_DOUBLE_COMPLEX,
                               operations[op]) == MPI_SUCCESS, "C complex reduce_local");
        check(output == expected, "C complex reduce_local value");
        input += rank;
        expected = op ? 1 : 0;
        for (int r = 0; r < ranks; ++r) {
            if (op) expected *= 1.5L + r + 2.0Li;
            else expected += 1.5L + r + 2.0Li;
        }
        check(MPI_Allreduce(&input, &output, 1, MPI_C_LONG_DOUBLE_COMPLEX,
                             operations[op], MPI_COMM_WORLD) == MPI_SUCCESS,
              "C complex allreduce");
        check(output == expected, "C complex allreduce value");
    }
    /* Parenthesized compound literals keep the array commas inside macro args. */
    TRANSPORT(long double, MPI_LONG_DOUBLE, ((long double[3]){1.5L, -2.25L, 0}), "C real");
    TRANSPORT(long double complex, MPI_C_LONG_DOUBLE_COMPLEX,
              ((long double complex[3]){1.5L - 2.25Li, 3.0L + 4.0Li, 0}), "C complex");
    long double real_in = 1.5L, real_out = 0;
    long double complex complex_in = 1.5L - 2.25Li, complex_out = 0;
    external(&real_in, &real_out, MPI_LONG_DOUBLE, 0);
    check(real_out == real_in, "C real external32 canonical value");
    external(&complex_in, &complex_out, MPI_C_LONG_DOUBLE_COMPLEX, 1);
    check(complex_out == complex_in, "C complex external32 canonical value");
    int total = 0;
    MPI_Allreduce(&failures, &total, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    if (rank == 0) printf("%s C floating ABI: long double storage=%zu mantissa=%d ranks=%d failures=%d\n",
                          total ? "FAIL" : "PASS", sizeof(long double), LDBL_MANT_DIG, ranks, total);
    MPI_Finalize();
    return total != 0;
}
