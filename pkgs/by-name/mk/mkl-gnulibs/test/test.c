#include <assert.h>
#include <dlfcn.h>
#include <mkl_cblas.h>
#include <omp.h>

int main()
{
    /* Verify MKL BLAS computation works via libmkl_rt */
    float u[] = { 1., 2., 3. };
    float v[] = { 4., 5., 6. };
    assert(cblas_sdot(3, u, 1, v, 1) == 32.);

    /* Verify GNU OpenMP is functional alongside MKL (simulates gcc+openmp consumers like pytorch) */
    int total = 0;
#pragma omp parallel reduction(+ : total)
    total += 1;
    assert(total >= 1);

    /* Verify Intel OpenMP is NOT loaded — its presence alongside libgomp causes the conflict
       that mkl-gnulibs exists to prevent */
    assert(dlopen("libiomp5.so", RTLD_NOLOAD) == NULL);

    return 0;
}
