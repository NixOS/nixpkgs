{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
}:

let
<<<<<<< HEAD
  version = "0.1";
in
stdenv.mkDerivation {
  pname = "niff";
  inherit version;
=======
  pname = "niff";
  version = "0.1";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "FRidh";
    repo = "niff";
    rev = "v${version}";
    sha256 = "1ziv5r57jzg2qg61izvkkyq1bz4p5nb6652dzwykfj3l2r3db4bi";
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
