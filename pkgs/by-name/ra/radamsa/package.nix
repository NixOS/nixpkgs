{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitLab,
  bash,
}:

let
  # Fetch explicitly, otherwise build will try to do so
  owl = fetchurl {
    name = "ol.c.gz";
    url = "https://haltp.org/files/ol-0.2.2.c.gz";
    hash = "sha256-/KhdrjaRAQhZjYpKJE33qMJxnngDrEbScHYuzkrvxVw=";
  };
  hex = fetchFromGitLab {
    owner = "owl-lisp";
    repo = "hex";
    rev = "e95ebd38e4f7ef8e3d4e653f432e43ce0a804ca6";
    hash = "sha256-OT04EGun8nKR6D55bMx8xj20dSFwxI7zP/8sdeFZAHQ=";
  };
in
stdenv.mkDerivation rec {
  pname = "radamsa";
  version = "0.7";

  src = fetchFromGitLab {
    owner = "akihe";
    repo = "radamsa";
    tag = "v${version}";
    hash = "sha256-cwTE+8mZujuVbm8vOpqGWCAYMwrWUXzLP7k3y7UoKtU=";
  };

  patchPhase = ''
    substituteInPlace ./tests/bd.sh  \
      --replace-fail "/bin/echo" echo
    substituteInPlace Makefile  \
      --replace-fail "cd lib && git clone https://gitlab.com/owl-lisp/hex.git" ""

    ln -s ${owl} ol.c.gz
    mkdir lib
    ln -s ${hex} lib/hex

    patchShebangs tests
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BINDIR="
  ];

  nativeCheckInputs = [ bash ];

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "General purpose fuzzer";
    mainProgram = "radamsa";
    longDescription = "Radamsa is a general purpose data fuzzer. It reads data from given sample files, or standard input if none are given, and outputs modified data. It is usually used to generate malformed data for testing programs.";
    homepage = "https://gitlab.com/akihe/radamsa";
    maintainers = [ ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
