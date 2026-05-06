{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  glib,
  libxml2,
  flex,
  bison,
  vips,
  gtk2,
  fftw,
  gsl,
  goffice,
  libgsf,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nip2";
  version = "8.9.1";

  src = fetchurl {
    url = "https://github.com/libvips/nip2/releases/download/v${finalAttrs.version}/nip2-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-t14m6z+5lPqpiOjgdDbKwqSWXCyrCL7zlo6BeoZtds0=";
  };

  patches = [
    (fetchpatch {
      name = "do-not-redeclare-statfs.patch";
      url = "https://github.com/libvips/nip2/commit/045268a78c40d7f546220504f971c728aebc00be.patch";
      hash = "sha256-A17+/Vmjf0l1Jpl22VL11gj5m6oFB8DnvkH2EHiRTw8=";
    })
    (fetchpatch {
      name = "declare-function-arguments-for-function-pointer.patch";
      url = "https://github.com/libvips/nip2/commit/8c60c517b59f806da84d57cb1d083a213b811151.patch";
      hash = "sha256-o5OHNSbUORGquhyCYCtGQTY74IfroByaa0UAXYsP484=";
    })
  ];

  nativeBuildInputs = [
    bison
    flex
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    glib
    libxml2
    vips
    gtk2
    fftw
    gsl
    goffice
    libgsf
  ];

  postFixup = ''
    wrapProgram $out/bin/nip2 --set VIPSHOME "$out"
  '';

  meta = {
    homepage = "https://github.com/libvips/nip2";
    description = "Graphical user interface for VIPS image processing system";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kovirobi ];
    platforms = lib.platforms.unix;
    mainProgram = "nip2";
  };
})
