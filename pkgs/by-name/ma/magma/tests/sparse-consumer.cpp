// Exercise the installed public MAGMA interface. No private headers or source
// translation units may be included: conversion output feeds later consumers.
#include <magma_v2.h>
#include <magmasparse.h>

#include <algorithm>
#include <cmath>
#include <complex>
#include <cstdio>
#include <stdexcept>
#include <string>
#include <vector>

#define CAT_(a, b) a##b
#define CAT(a, b) CAT_(a, b)
#define FN(name) CAT(CAT(magma_, PRECISION), name)
#define STRING_(x) #x
#define STRING(x) STRING_(x)
using Matrix = FN(_matrix);
using Complex = std::complex<double>;
using Dense = std::vector<Complex>;
#if defined(REAL_SINGLE)
using Scalar = float;
static Scalar scalar(Complex x) { return x.real(); }
static Complex complex(Scalar x) { return {x, 0}; }
constexpr double tolerance = 2e-5;
#elif defined(REAL_DOUBLE)
using Scalar = double;
static Scalar scalar(Complex x) { return x.real(); }
static Complex complex(Scalar x) { return {x, 0}; }
constexpr double tolerance = 2e-12;
#elif defined(COMPLEX_SINGLE)
using Scalar = magmaFloatComplex;
static Scalar scalar(Complex x) { return MAGMA_C_MAKE(x.real(), x.imag()); }
static Complex complex(Scalar x) { return {MAGMA_C_REAL(x), MAGMA_C_IMAG(x)}; }
constexpr double tolerance = 2e-5;
#else
using Scalar = magmaDoubleComplex;
static Scalar scalar(Complex x) { return MAGMA_Z_MAKE(x.real(), x.imag()); }
static Complex complex(Scalar x) { return {MAGMA_Z_REAL(x), MAGMA_Z_IMAG(x)}; }
constexpr double tolerance = 2e-12;
#endif

static void require(bool condition, const std::string &message) {
  if (!condition) throw std::runtime_error(message);
}
#define CHECK(call) do { int status = (call); require(status == 0, \
  std::string(#call) + ": status=" + std::to_string(status)); } while (0)

static int checks = 0;
static void pass(const std::string &name, double error = 0) {
  ++checks;
  std::printf("PASS %s error=%.17g\n", name.c_str(), error);
}
static Matrix empty(magma_storage_t storage = Magma_CSR,
                    magma_location_t location = Magma_CPU) {
  Matrix a{};
  a.storage_type = storage;
  a.memory_location = location;
  a.ownership = MagmaTrue;
  a.fill_mode = MagmaFull;
  return a;
}
static void release(Matrix &a, magma_queue_t queue) { CHECK(FN(mfree)(&a, queue)); }
static Matrix transfer(Matrix a, magma_location_t location, magma_queue_t queue) {
  Matrix b = empty(a.storage_type, location);
  CHECK(FN(mtransfer)(a, &b, a.memory_location, location, queue));
  return b;
}
static Matrix convert(Matrix a, magma_storage_t storage, magma_queue_t queue) {
  Matrix b = empty(storage, a.memory_location);
  CHECK(FN(mconvert)(a, &b, a.storage_type, storage, queue));
  return b;
}

struct CSR {
  int rows, cols;
  std::vector<magma_index_t> pointers, indices;
  std::vector<Scalar> values;
  Matrix view() {
    Matrix a = empty();
    a.ownership = MagmaFalse;
    a.num_rows = rows; a.num_cols = cols;
    a.nnz = a.true_nnz = values.size();
    a.row = pointers.data(); a.col = indices.data(); a.val = values.data();
    return a;
  }
};
static CSR rectangular(bool zero = false) {
  CSR a{3, 5, {0, 3, 6, 9}, {0, 2, 4, 1, 2, 4, 0, 3, 4}, {}};
  for (int i = 1; i <= 9; ++i) a.values.push_back(scalar({double(i), -double(i)}));
  if (zero) {
    std::fill(a.pointers.begin(), a.pointers.end(), 0);
    a.indices.clear(); a.values.clear();
  }
  return a;
}
// This oracle only reads documented CSR/CSC/dense storage; it never calls a
// MAGMA conversion or arithmetic routine to calculate the expected values.
static Dense dense(Matrix a) {
  require(a.memory_location == Magma_CPU, "oracle requires CPU storage");
  Dense result(a.num_rows * a.num_cols);
  if (a.storage_type == Magma_DENSE) {
    require(a.major == MagmaColMajor, "column-major dense result required");
    for (int r = 0; r < a.num_rows; ++r)
      for (int c = 0; c < a.num_cols; ++c)
        result[r * a.num_cols + c] = complex(a.val[c * a.num_rows + r]);
    return result;
  }
  require(a.storage_type == Magma_CSR || a.storage_type == Magma_CSC,
          "unexpected sparse output format");
  bool csc = a.storage_type == Magma_CSC;
  int outer = csc ? a.num_cols : a.num_rows;
  int inner = csc ? a.num_rows : a.num_cols;
  auto *pointers = csc ? a.col : a.row;
  auto *indices = csc ? a.row : a.col;
  require(pointers && pointers[0] == 0 && pointers[outer] == a.nnz,
          "invalid sparse pointer endpoints");
  for (int i = 0; i < outer; ++i) {
    require(0 <= pointers[i] && pointers[i] <= pointers[i + 1] &&
            pointers[i + 1] <= a.nnz, "invalid sparse pointer interval");
    for (int k = pointers[i]; k < pointers[i + 1]; ++k) {
      require(indices[k] >= 0 && indices[k] < inner, "sparse index out of range");
      int r = csc ? indices[k] : i, c = csc ? i : indices[k];
      result[r * a.num_cols + c] += complex(a.val[k]);
    }
  }
  return result;
}
static void expect(const std::string &name, Matrix a, int rows, int cols,
                   const Dense &reference, magma_queue_t queue) {
  require(a.num_rows == rows && a.num_cols == cols, name + ": wrong shape");
  Matrix host = transfer(a, Magma_CPU, queue);
  CHECK(cudaDeviceSynchronize());
  Dense actual = dense(host);
  release(host, queue);
  double error = 0, scale = 1;
  require(actual.size() == reference.size(), name + ": wrong element count");
  for (size_t i = 0; i < actual.size(); ++i) {
    require(std::isfinite(actual[i].real()) && std::isfinite(actual[i].imag()),
            name + ": non-finite result");
    error = std::max(error, std::abs(actual[i] - reference[i]));
    scale = std::max(scale, std::abs(reference[i]));
  }
  require(error <= tolerance * scale, name + ": numerical error=" + std::to_string(error));
  pass(name, error);
}

static void memory(magma_queue_t queue) {
  for (auto location : {Magma_CPU, Magma_DEV}) {
    Matrix a = empty(Magma_CSR, location);
    release(a, location == Magma_CPU ? nullptr : queue);
    release(a, location == Magma_CPU ? nullptr : queue);
    pass(location == Magma_CPU ? "CPU-empty-repeated-free" : "DEV-empty-repeated-free");
  }
  Matrix invalid = empty();
  invalid.memory_location = static_cast<magma_location_t>(-1);
  require(FN(mfree)(&invalid, queue) == MAGMA_ERR_INVALID_PTR, "invalid-location free status");
  pass("invalid-location-free");
  CSR input = rectangular();
  Matrix owned = transfer(input.view(), Magma_CPU, queue);
  release(owned, nullptr);
  require(!owned.val && !owned.row && !owned.col, "CPU free leaves data pointers");
  release(owned, nullptr);
  pass("CPU-owned-repeated-free");
  Dense before = dense(input.view());
  Matrix borrowed = input.view();
  release(borrowed, nullptr);
  require(dense(input.view()) == before, "borrowed CPU storage changed");
  pass("CPU-borrowed-free");
  std::vector<magma_index_t> rows{0, 2}, cols{1, 4};
  std::vector<Scalar> values{scalar({2, -1}), scalar({3, .5})};
  Matrix coo = empty(Magma_COO);
  coo.ownership = MagmaFalse; coo.num_rows = 3; coo.num_cols = 5;
  coo.nnz = coo.true_nnz = 2; coo.rowidx = rows.data(); coo.col = cols.data(); coo.val = values.data();
  for (auto location : {Magma_CPU, Magma_DEV}) {
    Matrix owned_coo = transfer(coo, location, queue);
    release(owned_coo, location == Magma_CPU ? nullptr : queue);
    require(!owned_coo.val && !owned_coo.rowidx && !owned_coo.col, "COO free leaves data pointers");
    release(owned_coo, location == Magma_CPU ? nullptr : queue);
    pass(location == Magma_CPU ? "CPU-owned-COO-free" : "DEV-owned-COO-free");
  }
}
static void addition(magma_queue_t queue) {
  CSR a{3, 3, {0, 2, 3, 4}, {0, 2, 1, 0},
        {scalar({1, 1}), scalar({2, -1}), scalar({3, 2}), scalar({-1, .5})}};
  CSR b{3, 3, {0, 1, 3, 5}, {1, 0, 2, 1, 2},
        {scalar({4, -1}), scalar({5, .5}), scalar({6, 2}), scalar({7, -1}), scalar({8, .25})}};
  for (bool same : {false, true}) {
    Matrix av = a.view(), bv = same ? a.view() : b.view();
    Dense ah = dense(av), bh = dense(bv);
    Matrix da = transfer(av, Magma_DEV, queue), db = transfer(bv, Magma_DEV, queue);
    Matrix ca = convert(da, Magma_CSRCOO, queue), cb = convert(db, Magma_CSRCOO, queue);
    for (int formats = 0; formats < 4; ++formats) for (int zeros = 0; zeros < 4; ++zeros) {
      Scalar alpha = scalar(zeros & 1 ? Complex{} : Complex{2, .25});
      Scalar beta = scalar(zeros & 2 ? Complex{} : Complex{-.5, .75});
      Dense reference(9);
      for (int i = 0; i < 9; ++i) reference[i] = complex(alpha) * ah[i] + complex(beta) * bh[i];
      Matrix c = empty(Magma_CSR, Magma_DEV);
      CHECK(FN(cuspaxpy)(&alpha, formats & 1 ? ca : da, &beta, formats & 2 ? cb : db, &c, queue));
      require(c.storage_type == Magma_CSR, "addition must return complete CSR storage");
      expect("addition-same=" + std::to_string(same) + "-formats=" + std::to_string(formats) + "-zeros=" + std::to_string(zeros), c, 3, 3, reference, queue);
      release(c, queue);
    }
    release(ca, queue); release(cb, queue); release(da, queue); release(db, queue);
  }
}
static void product(magma_queue_t queue) {
  CSR a = rectangular();
  CSR b{5, 2, {0, 1, 2, 3, 4, 6}, {0, 1, 0, 1, 0, 1},
        {scalar({1, .5}), scalar({2, -.5}), scalar({3, 1}), scalar({4, -1}), scalar({5, 2}), scalar({6, -2})}};
  Dense ah = dense(a.view()), bh = dense(b.view()), reference(6);
  for (int r = 0; r < 3; ++r)
    for (int c = 0; c < 2; ++c)
      for (int k = 0; k < 5; ++k) reference[r * 2 + c] += ah[r * 5 + k] * bh[k * 2 + c];
  Matrix da = transfer(a.view(), Magma_DEV, queue), db = transfer(b.view(), Magma_DEV, queue);
  Matrix ca = convert(da, Magma_CSRCOO, queue), cb = convert(db, Magma_CSRCOO, queue);
  for (int repeat = 0; repeat < 8; ++repeat) {
    Matrix c = empty(Magma_CSR, Magma_DEV);
    CHECK(FN(cuspmm)(repeat & 1 ? ca : da, repeat & 2 ? cb : db, &c, queue));
    require(c.storage_type == Magma_CSR, "product must return complete CSR storage");
    expect("rectangular-product-" + std::to_string(repeat), c, 3, 2, reference, queue);
    release(c, queue);
  }
  Matrix invalid = db, failed = empty(Magma_CSR, Magma_DEV);
  invalid.num_rows = -1;
  require(FN(cuspmm)(da, invalid, &failed, queue) != MAGMA_SUCCESS,
          "invalid product descriptor accepted");
  release(failed, queue);
  pass("product-invalid-descriptor");
  release(ca, queue); release(cb, queue); release(da, queue); release(db, queue);
}
static void conversion(magma_queue_t queue) {
  for (bool zero : {false, true}) {
    CSR input = rectangular(zero);
    Dense reference = dense(input.view());
    Matrix a = transfer(input.view(), Magma_DEV, queue), csc = empty(), back = empty();
    CHECK(FN(mconvert)(a, &csc, Magma_CSR, Magma_CSC, queue));
    expect("CSR-to-CSC-zero=" + std::to_string(zero), csc, 3, 5, reference, queue);
    CHECK(FN(mconvert)(csc, &back, Magma_CSC, Magma_CSR, queue));
    expect("CSC-to-CSR-zero=" + std::to_string(zero), back, 3, 5, reference, queue);
    release(back, queue); release(csc, queue);
    for (bool conjugate : {false, true}) {
      Matrix transposed = empty();
      CHECK(conjugate ? FN(mtransposeconjugate)(a, &transposed, queue)
                      : FN(mtranspose)(a, &transposed, queue));
      Dense expected(15);
      for (int r = 0; r < 3; ++r)
        for (int c = 0; c < 5; ++c)
          expected[c * 3 + r] = conjugate ? std::conj(reference[r * 5 + c]) : reference[r * 5 + c];
      expect("transpose-conjugate=" + std::to_string(conjugate) + "-zero=" + std::to_string(zero),
             transposed, 5, 3, expected, queue);
      release(transposed, queue);
    }
    release(a, queue);
  }
  // Deliberately unsorted COO: sorting must permute values along with indices.
  std::vector<magma_index_t> rows{2, 0, 1, 0, 2}, cols{4, 2, 1, 0, 3};
  std::vector<Scalar> values;
  Dense reference(15);
  for (int i = 0; i < 5; ++i) {
    values.push_back(scalar({double(i + 1), double(2 - i)}));
    reference[rows[i] * 5 + cols[i]] = complex(values.back());
  }
  Matrix coo = empty(Magma_COO);
  coo.ownership = MagmaFalse; coo.num_rows = 3; coo.num_cols = 5;
  coo.nnz = coo.true_nnz = 5; coo.rowidx = rows.data(); coo.col = cols.data(); coo.val = values.data();
  Matrix device = transfer(coo, Magma_DEV, queue), csr = empty();
  CHECK(FN(mconvert)(device, &csr, Magma_COO, Magma_CSR, queue));
  require(csr.drowidx == nullptr, "COO conversion leaves a dangling scratch pointer");
  expect("unsorted-COO-to-CSR", csr, 3, 5, reference, queue);
  release(csr, queue); release(device, queue);
}
static void spmv(magma_queue_t queue) {
  for (bool zero : {false, true}) {
    CSR input = rectangular(zero);
    Dense reference = dense(input.view());
    Matrix csr = transfer(input.view(), Magma_DEV, queue), csc = empty();
    CHECK(FN(mconvert)(csr, &csc, Magma_CSR, Magma_CSC, queue));
    for (bool column_storage : {false, true}) for (int rhs : {1, 3}) {
      std::vector<Scalar> xv(5 * rhs), yv(3 * rhs);
      Dense expected(3 * rhs);
      Scalar alpha = scalar({1.25, .5}), beta = scalar({-.75, .25});
      for (int j = 0; j < rhs; ++j) {
        for (int k = 0; k < 5; ++k) xv[j * 5 + k] = scalar({.3 + k + .7 * j, .2 - .1 * k});
        for (int r = 0; r < 3; ++r) {
          yv[j * 3 + r] = scalar({.4 + r + .3 * j, -.2 + r * .1});
          Complex sum{};
          for (int k = 0; k < 5; ++k) sum += reference[r * 5 + k] * complex(xv[j * 5 + k]);
          expected[r * rhs + j] = complex(alpha) * sum + complex(beta) * complex(yv[j * 3 + r]);
        }
      }
      Matrix x = empty(Magma_DENSE), y = empty(Magma_DENSE);
      x.ownership = y.ownership = MagmaFalse;
      x.major = y.major = MagmaColMajor;
      x.num_rows = x.ld = 5; y.num_rows = y.ld = 3; x.num_cols = y.num_cols = rhs;
      x.nnz = 5 * rhs; y.nnz = 3 * rhs; x.val = xv.data(); y.val = yv.data();
      Matrix dx = transfer(x, Magma_DEV, queue), dy = transfer(y, Magma_DEV, queue);
      CHECK(FN(_spmv)(alpha, column_storage ? csc : csr, dx, beta, dy, queue));
      expect("spmv-CSC=" + std::to_string(column_storage) + "-rhs=" + std::to_string(rhs) + "-zero=" + std::to_string(zero),
             dy, 3, rhs, expected, queue);
      release(dx, queue); release(dy, queue);
    }
    release(csc, queue); release(csr, queue);
  }
}
int main(int argc, char **argv) {
  try {
    require(argc == 2, "usage: magma-sparse-PRECISION memory|addition|product|conversion|spmv");
    CHECK(magma_init());
    int devices = 0; CHECK(cudaGetDeviceCount(&devices));
    require(devices > 0, "a real CUDA device is required");
    magma_queue_t queue = nullptr; magma_queue_create(0, &queue);
    std::string group = argv[1];
    if (group == "memory") memory(queue);
    else if (group == "addition") addition(queue);
    else if (group == "product") product(queue);
    else if (group == "conversion") conversion(queue);
    else if (group == "spmv") spmv(queue);
    else throw std::runtime_error("unknown group: " + group);
    CHECK(cudaDeviceSynchronize());
    magma_queue_destroy(queue); CHECK(magma_finalize());
    std::printf("SUCCESS precision=%s group=%s checks=%d\n", STRING(PRECISION), group.c_str(), checks);
    return 0;
  } catch (const std::exception &error) {
    std::fprintf(stderr, "FAIL: %s\n", error.what());
    return 1;
  }
}
