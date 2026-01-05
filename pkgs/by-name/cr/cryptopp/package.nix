{
  lib,
  stdenv,
  fetchFromGitHub,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !enableStatic,
  # Multi-threading with OpenMP is disabled by default
  # more info on https://www.cryptopp.com/wiki/OpenMP
  withOpenMP ? false,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "crypto++";
  version = "8.9.0";
  underscoredVersion = lib.strings.replaceStrings [ "." ] [ "_" ] version;

  src = fetchFromGitHub {
    owner = "weidai11";
    repo = "cryptopp";
    rev = "CRYPTOPP_${underscoredVersion}";
    hash = "sha256-HV+afSFkiXdy840JbHBTR8lLL0GMwsN3QdwaoQmicpQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace GNUmakefile \
      --replace "AR = /usr/bin/libtool" "AR = ar" \
      --replace "ARFLAGS = -static -o" "ARFLAGS = -cru"
  '';

  buildInputs = lib.optionals (stdenv.cc.isClang && withOpenMP) [ llvmPackages.openmp ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  buildFlags =
    lib.optional enableStatic "static" ++ lib.optional enableShared "shared" ++ [ "libcryptopp.pc" ];

  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ];
  CXXFLAGS = lib.optionals withOpenMP [ "-fopenmp" ];

  doCheck = true;

  # always built for checks but install static lib only when necessary
  preInstall = lib.optionalString (!enableStatic) "rm -f libcryptopp.a";

  installTargets = [ "install-lib" ];
  installFlags = [ "LDCONF=true" ];

  meta = {
    description = "Free C++ class library of cryptographic schemes";
    homepage = "https://cryptopp.com/";
    changelog = [
      "https://raw.githubusercontent.com/weidai11/cryptopp/CRYPTOPP_${underscoredVersion}/History.txt"
      "https://github.com/weidai11/cryptopp/releases/tag/CRYPTOPP_${underscoredVersion}"
    ];
    license = with lib.licenses; [
      boost
      publicDomain
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ c0bw3b ];
  };
}
