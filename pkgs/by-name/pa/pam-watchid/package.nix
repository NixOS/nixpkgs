{
  lib,
  swiftPackages,
  swift,
  swiftpm,
  fetchFromGitHub,
}:

swiftPackages.stdenv.mkDerivation {
  pname = "pam-watchid";
  version = "2-unstable-2024-12-24";

  src = fetchFromGitHub {
    owner = "mostpinkest";
    repo = "pam-watchid";
    rev = "bb9c6ea62207dd9d41a08ca59c7a1f5d6fa07189";
    hash = "sha256-6SqSACoG7VkyYfz+xyU/L2J69RxHTTvzGexjGB2gDuY=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/lib
    cp $binPath/libpam-watchid.dylib $out/lib/pam_watchid.so
  '';

  meta = {
    description = "PAM plugin module that allows the Apple Watch to be used for authentication";
    homepage = "https://github.com/mostpinkest/pam-watchid";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.samasaur ];
    platforms = lib.platforms.darwin;
  };
}
