{ lib
, opencv
, kokkos
}:

_: prev: {
  pname = "${prev.pname}-example";

  buildInputs = prev.buildInputs ++ [
    opencv
    kokkos
  ];

  cmakeFlags = prev.cmakeFlags ++ [
    (lib.cmakeBool "GINKGO_BUILD_EXAMPLES" true)
  ];

  postPatch = prev.postPatch + ''
    patchShebangs examples

    # Guess a kokkos version mismatch with this release version
    substituteInPlace examples/kokkos_assembly/kokkos_assembly.cpp \
      --replace "Kokkos::Experimental::abs" "Kokkos::abs"
  '';

  postInstall = prev.postInstall + ''
    mkdir -p $out/bin

    find examples -type f -executable \
      -exec patchelf {} --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" \; \
      -exec mv {} $out/bin \;
  '';

  passthru = {
    inherit (prev.passthru) mpi openmp;
  };

  # `libopencv_gapi.so.4.7.0: undefined reference to `std::condition_variable::wait(std::unique_lock<std::mutex>&)@GLIBCXX_3.4.30'`
  meta.broken = lib.hasSuffix "-cuda" prev.pname;
}
