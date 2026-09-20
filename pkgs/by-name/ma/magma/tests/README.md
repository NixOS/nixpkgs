`magma.tests.sparse` builds four small consumers against the exact parent
package's installed public headers and `libmagma_sparse`. It takes all include
and library flags from `magma.pc`, after clearing stdenv dependency flags. The
build is safe to cross-compile and does not need a GPU.

Run `sparse-runtime.py` on the host with a real NVIDIA driver; its module docstring
contains the command. The script verifies the producer recorded in the test
output, checks each executable's ELF architecture, and records commands, binary
hashes, numerical errors and status in a fresh evidence directory. Missing GPUs
and missing cases are failures. Single- and double-precision, real and complex
variants each execute these 65 checks:

- Seven ownership/status cases: CPU/device empty and repeated free, invalid
  location, owned/borrowed CPU storage, and owned CPU/device COO storage.
- Thirty-two sparse additions: overlapping and different sparsity patterns,
  CSR/CSRCOO input combinations, complex coefficients where applicable, and
  either/both coefficients equal to zero.
- Nine sparse products: repeated rectangular 3×5 by 5×2 multiplication with all
  CSR/CSRCOO input combinations, and an invalid descriptor rejected through the
  public API.
- Nine conversions: nonempty/empty rectangular CSR↔CSC, ordinary and conjugate
  transpose, and unsorted COO→CSR with values permuted alongside indices.
- Eight sparse/dense products: CSR/CSC, one/three right-hand sides, and
  nonempty/empty matrices, with nontrivial alpha and beta.

Dense reference arithmetic uses `std::complex<double>` independently of MAGMA;
real variants remove imaginary components when constructing their inputs.
Shape, sparse pointer/index validity, finiteness and numerical errors are
checked. CSC SpMV uses the output of the public conversion routine directly,
so producer/consumer storage-layout disagreement cannot be hidden by a manually
constructed descriptor.

These are installed numerical and public ownership/status regressions. They do
not measure every allocation or inject cuSPARSE failures; the separate focused
source controls establish those cleanup/error-path contracts. They do not copy
MAGMA private helper implementations into the installed test.
