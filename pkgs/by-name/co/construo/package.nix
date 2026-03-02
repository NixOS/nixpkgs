{
  lib,
  stdenv,
  fetchurl,
  libx11,
  zlib,
  xorgproto,
  withLibGL ? !stdenv.hostPlatform.isDarwin,
  libGL,
  withLibGLU ? !stdenv.hostPlatform.isDarwin,
  libGLU,
  withLibglut ? !stdenv.hostPlatform.isDarwin,
  libglut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "construo";
  version = "0.2.3";

  src = fetchurl {
    url = "https://github.com/Construo/construo/releases/download/v${finalAttrs.version}/construo-${finalAttrs.version}.tar.gz";
    sha256 = "1wmj527hbj1qv44cdsj6ahfjrnrjwg2dp8gdick8nd07vm062qxa";
  };

  buildInputs = [
    libx11
    zlib
    xorgproto
  ]
  ++ lib.optional withLibGL libGL
  ++ lib.optional withLibGLU libGLU
  ++ lib.optional withLibglut libglut;

  preConfigure = ''
    substituteInPlace src/Makefile.in \
      --replace games bin
  '';

  meta = {
    description = "Masses and springs simulation game";
    mainProgram = "construo.x11";
    homepage = "http://fs.fsf.org/construo/";
    license = lib.licenses.gpl3;
    priority = 10;
  };
})
