{ lib
, gflags
, rapidjson-unstable
}:

_: prev: {
  pname = "${prev.pname}-benchmark";

  buildInputs = prev.buildInputs ++ [
    gflags
    rapidjson-unstable
  ];

  cmakeFlags = prev.cmakeFlags ++ [
    (lib.cmakeBool "GINKGO_BUILD_BENCHMARKS" true)
  ];

  postPatch = prev.postPatch + ''
    # `rapidjson` doesn't have a shared library for this to link to?
    substituteInPlace benchmark/CMakeLists.txt \
      --replace " rapidjson)" ")"
  '';

  postInstall = prev.postInstall + ''
    mkdir -p $out/bin

    find benchmark -type f -executable \
      -exec patchelf {} --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" \; \
      -exec mv {} $out/bin \;
  '';

  passthru = {
    inherit (prev.passthru) mpi openmp;
  };

  meta.broken = lib.hasSuffix "-hip" prev.pname; # This release likely uses an outdated rocThrust release
}
