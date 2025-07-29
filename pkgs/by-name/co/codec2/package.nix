{
  lib,
  testers,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  cmake,
  freedvSupport ? false,
  lpcnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codec2";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "codec2";
    rev = finalAttrs.version;
    hash = "sha256-69Mp4o3MgV98Fqfai4txv5jQw2WpoPuoWcwHsNAFPQM=";
  };

  patches = [
    # Fix nix-store path dupliucations
    ./fix-pkg-config.patch
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    buildPackages.stdenv.cc # needs to build a C program to run at build time
  ];

  buildInputs = lib.optionals freedvSupport [
    lpcnet
  ];

  # we need to unset these variables from stdenv here and then set their equivalents in the cmake flags
  # otherwise it will pass the same compiler to the native and cross phases and crash trying to execute
  # host binaries (generate_codebook) on the build system.
  preConfigure = ''
    unset CC
    unset CXX
  '';

  postInstall = ''
    install -Dm0755 src/{c2enc,c2dec,c2sim,freedv_rx,freedv_tx,cohpsk_*,fdmdv_*,fsk_*,ldpc_*,ofdm_*} -t $out/bin/
  '';

  postFixup =
    # Swap keyword order to satisfy SWIG parser
    ''
      sed -r -i 's/(\<_Complex)(\s+)(float|double)/\3\2\1/' $dev/include/$pname/freedv_api.h
    ''
    +
    # generated cmake module is not compatible with multiple outputs
    ''
      substituteInPlace $dev/lib/cmake/codec2/codec2-config.cmake --replace-fail \
        '"''${_IMPORT_PREFIX}/include/codec2' \
        "\"$dev/include/codec2"
    '';

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/freedv_rx contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DCMAKE_C_COMPILER=${stdenv.cc.targetPrefix}cc"
    "-DCMAKE_CXX_COMPILER=${stdenv.cc.targetPrefix}c++"
  ]
  ++ lib.optionals freedvSupport [
    "-DLPCNET=ON"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Speech codec designed for communications quality speech at low data rates";
    homepage = "https://www.rowetel.com/codec2.html";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ markuskowa ];
    pkgConfigModules = [ "codec2" ];
  };
})
