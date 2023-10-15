{ lib
, stdenv
, callPackage
, fetchFromGitHub
, fetchpatch
, gitUpdater
, cmake
, mpi
, llvmPackages
, papi
, metis
, hwloc
, rocmUnfree ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ginkgo-hpc";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ginkgo-project";
    repo = "ginkgo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uKUxlNlUe4HaPawEno9C57D5EFz63RB+Ei4HoIgyYjM=";
  };

  # https://github.com/ginkgo-project/ginkgo/issues/1428
  patches = [
    (fetchpatch {
      name = "fix-hip-jacobi-transposition-compilation.patch";
      url = "https://github.com/ginkgo-project/ginkgo/commit/094e58410c5fbdd7c74dbe548017d44f2b111667.patch";
      hash = "sha256-JzKQW6XhqsBSQ0f53xuYzpkbbY5rrUFd0OvoqH57Oa0=";
    })

    (fetchpatch {
      name = "avoid-changing-thread-indexing-scheme.patch";
      url = "https://github.com/ginkgo-project/ginkgo/commit/a96bb1cb50217b5585abf01dab13d415e0b11b7f.patch";
      hash = "sha256-abl7MK8j1tlbK1RPiREz82GKAKDGFY6QdjSZyQAY5Tw=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    finalAttrs.passthru.mpi
    finalAttrs.passthru.openmp
    papi
    metis
    hwloc
  ];

  cmakeFlags = [
    (lib.cmakeBool "GINKGO_BUILD_TESTS" false)
    (lib.cmakeBool "GINKGO_BUILD_EXAMPLES" false)
    (lib.cmakeBool "GINKGO_BUILD_BENCHMARKS" false)
    (lib.cmakeBool "GINKGO_BUILD_REFERENCE" true)
    (lib.cmakeBool "GINKGO_BUILD_OMP" true)
    (lib.cmakeBool "GINKGO_BUILD_MPI" true)
    (lib.cmakeBool "GINKGO_MIXED_PRECISION" true)
  ];

  # For passthru overlays
  postPatch = "";
  postInstall = "";

  passthru = {
    inherit mpi;
    inherit (llvmPackages) openmp;
    cuda = finalAttrs.finalPackage.overrideAttrs (callPackage ./overlays/cuda.nix { });
    hip = finalAttrs.finalPackage.overrideAttrs (callPackage ./overlays/hip.nix { inherit rocmUnfree; });
    dpc = finalAttrs.finalPackage.overrideAttrs (callPackage ./overlays/dpc.nix { });
    doc = finalAttrs.finalPackage.overrideAttrs (callPackage ./overlays/doc.nix { });
    test = finalAttrs.finalPackage.overrideAttrs (callPackage ./overlays/test.nix { });
    example = finalAttrs.finalPackage.overrideAttrs (callPackage ./overlays/example.nix { });
    benchmark = finalAttrs.finalPackage.overrideAttrs (callPackage ./overlays/benchmark.nix { });
    updateScript = gitUpdater { rev-prefix = "v"; };

    impureTests = {
      runTests = callPackage ./test.nix {
        ginkgo-hpc =
          if lib.hasSuffix "-test" finalAttrs.pname then
            finalAttrs.finalPackage.overrideAttrs { doCheck = true; }
          else
            finalAttrs.finalPackage.test.overrideAttrs { doCheck = true; };
      };
    };
  };

  meta = with lib; {
    description = "Numerical linear algebra software package";
    homepage = "https://github.com/ginkgo-project/ginkgo";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ Madouura keldu ];
  };
})
