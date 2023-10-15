{ lib
, gtest
, numactl
}:

_: prev: {
  pname = "${prev.pname}-test";

  buildInputs = prev.buildInputs ++ [
    gtest
    numactl
  ];

  cmakeFlags = prev.cmakeFlags ++ [
    (lib.cmakeBool "GINKGO_BUILD_TESTS" true)
    (lib.cmakeBool "GINKGO_FAST_TESTS" true)
  ];

  passthru = {
    inherit (prev.passthru) mpi openmp impureTests;
  };
}
