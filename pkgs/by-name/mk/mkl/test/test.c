#include <assert.h>

#include <mkl_cblas.h>

int main() {
  float u[] = {1., 2., 3.};
  float v[] = {4., 5., 6.};

  float dp = cblas_sdot(3, u, 1, v, 1);

  assert(dp == 32.);
}
