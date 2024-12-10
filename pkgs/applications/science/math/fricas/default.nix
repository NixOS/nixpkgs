{
  lib,
  stdenv,
  fetchFromGitHub,
  sbcl,
  libX11,
  libXpm,
  libICE,
  libSM,
  libXt,
  libXau,
  libXdmcp,
}:

stdenv.mkDerivation rec {
  pname = "fricas";
  version = "1.3.10";

  src = fetchFromGitHub {
    owner = "fricas";
    repo = "fricas";
    rev = version;
    sha256 = "sha256-T1xDndDnHq/hmhTWWO3Eu0733u8+C8sJMCF6pbLU2GI=";
  };

  buildInputs = [
    sbcl
    libX11
    libXpm
    libICE
    libSM
    libXt
    libXau
    libXdmcp
  ];

  # Remove when updating to next version
  configurePhase = ''
    ./configure --prefix=$out --with-lisp='sbcl --dynamic-space-size 3072'
  '';

  dontStrip = true;

  meta = {
    homepage = "https://fricas.github.io";
    description = "An advanced computer algebra system";
    license = lib.licenses.bsd3;

    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sprock ];
  };
}
