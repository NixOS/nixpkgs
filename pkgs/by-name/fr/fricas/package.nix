{
  lib,
  stdenv,
  fetchFromGitHub,
  sbcl,
  libx11,
  libxpm,
  libice,
  libsm,
  libxt,
  libxau,
  libxdmcp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fricas";
  version = "1.3.12";

  src = fetchFromGitHub {
    owner = "fricas";
    repo = "fricas";
    rev = finalAttrs.version;
    sha256 = "sha256-GUGJR65K1bPC0D36l4Yyj3GOsWtUrSKLu6JnlfjHzDc=";
  };

  buildInputs = [
    sbcl
    libx11
    libxpm
    libice
    libsm
    libxt
    libxau
    libxdmcp
  ];

  # Remove when updating to next version
  configurePhase = ''
    runHook preConfigure

    ./configure --prefix=$out --with-lisp='sbcl --dynamic-space-size 3072'

    runHook postConfigure
  '';

  dontStrip = true;

  meta = {
    homepage = "https://fricas.github.io";
    description = "Advanced computer algebra system";
    license = lib.licenses.bsd3;

    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sprock ];
  };
})
