{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  glib,
  pkg-config,
  libfm-extra,
}:

stdenv.mkDerivation rec {
  pname = "menu-cache";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/menu-cache-${version}.tar.xz";
    sha256 = "1iry4zlpppww8qai2cw4zid4081hh7fz8nzsp5lqyffbkm2yn0pd";
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

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    glib
    libfm-extra
  ];

  meta = with lib; {
    description = "Library to read freedesktop.org menu files";
    homepage = "https://blog.lxde.org/tag/menu-cache/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
