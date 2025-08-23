{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  glib,
  pkg-config,
  libfm-extra,
  autoreconfHook,
  gtk-doc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "menu-cache";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "menu-cache";
    tag = finalAttrs.version;
    hash = "sha256-UPSBAoDjI4nwyDsGK5yIrAR03WhGMSxv1IePSQ3SzxE=";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/lxde/menu-cache/pull/19
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/lxde/menu-cache/commit/1ce739649b4d66339a03fc0ec9ee7a2f7c141780.patch";
      sha256 = "08x3h0w2pl8ifj83v9jkf4j3zxcwsyzh251divlhhnwx0rw1pyn7";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gtk-doc
  ];

  buildInputs = [
    glib
    libfm-extra
  ];

  meta = {
    description = "Library to read freedesktop.org menu files";
    homepage = "https://blog.lxde.org/tag/menu-cache/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
