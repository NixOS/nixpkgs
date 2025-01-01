{ lib, stdenv, fetchFromGitHub, sbcl, libX11, libXpm, libICE, libSM, libXt, libXau, libXdmcp }:

stdenv.mkDerivation rec {
  pname = "fricas";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner = "fricas";
    repo = "fricas";
    rev = version;
    sha256 = "sha256-EX/boSs6rK4RrJ5W6Rd0TSHsbQsNiFI1evFuNPBMeu8=";
  };

  buildInputs = [ sbcl libX11 libXpm libICE libSM libXt libXau libXdmcp ];

  # Remove when updating to next version
  configurePhase = ''
    ./configure --prefix=$out --with-lisp='sbcl --dynamic-space-size 3072'
  '';

  dontStrip = true;

  meta = {
    homepage = "https://fricas.github.io";
    description = "Advanced computer algebra system";
    license = lib.licenses.bsd3;

    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sprock ];
  };
}
