{
  lib,
  stdenv,
  fetchurl,
  guile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-opengl";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://gnu/guile-opengl/guile-opengl-${finalAttrs.version}.tar.gz";
    hash = "sha256-uPCH7CiCPQmfuELDupQQS7BPqecIFmSHpHGYnhwXbGU=";
  };

  nativeBuildInputs = [
    pkg-config
    guile
  ];

  meta = {
    homepage = "https://www.gnu.org/software/guile-opengl/";
    description = "Guile bindings for the OpenGL graphics API";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
