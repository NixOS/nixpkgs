{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
}:

let
  version = "0.1";
in
stdenv.mkDerivation {
  pname = "niff";
  inherit version;

  src = fetchFromGitHub {
    owner = "FRidh";
    repo = "niff";
    rev = "v${version}";
    hash = "sha256-cZHVRhZ0SDc9/00UY5Ytl/wVsJ9z/xjMw+J9eUouO/4=";
  };

  buildInputs = [ python3 ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp niff $out/bin/niff
  '';

  meta = {
    description = "Program that compares two Nix expressions and determines which attributes changed";
    homepage = "https://github.com/FRidh/niff";
    license = lib.licenses.mit;
    mainProgram = "niff";
  };
}
