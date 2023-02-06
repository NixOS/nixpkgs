{ lib, stdenv, overrideCC, clang_14, Libsystem, fetchFromGitHub, openssl, sqlite }:

let
  # Package requires newer version of Clang than the one provided in `stdenv`.
  # Override is taken from `../../../../os-specific/darwin/apple-sdk-11.0/default.nix` and is
  # required for package to build on `x86_64-darwin`.
  clang = clang_14.override {
    bintools = stdenv.cc.bintools.override { libc = Libsystem; };
    libc = Libsystem;
  };
in

(if stdenv.isDarwin then overrideCC stdenv clang else stdenv).mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20230206";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = pname;
    rev = version;
    sha256 = "sha256-i3I4VJ56YAwO4HG3mAhiQuR5jFCUpZ40hIpeflcLBhw=";
  };

  postPatch = ''
    patchShebangs BUILDSCRIPT_MULTIPROC.bash44
  '';

  buildInputs = [ openssl sqlite ];

  buildPhase = ''
    runHook preBuild
    ./BUILDSCRIPT_MULTIPROC.bash44${lib.optionalString stdenv.isDarwin " --config nixpkgs-darwin"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp signalbackup-tools $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
  };
}
