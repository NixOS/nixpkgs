{
  stdenv,
  cmake,
  pkg-config,
  gobject-introspection,
  vala,
  glib,
  libsndfile,
  zlib,
  bzip2,
  xz,
  libsamplerate,
  intltool,
  pcre,
  util-linux,
  libselinux,
  libsepol,
  fetchurl,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "libmirage";
  version = "3.2.10";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/${pname}-${version}.tar.xz";
    hash = "sha256-+T5Gu3VcprCkSJcq/kTySRnNI7nc+GbRtctLkzPhgK4=";
  };

  env = {
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "out"}/share/gir-1.0";
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";
  };

  buildInputs = [
    glib
    libsndfile
    zlib
    bzip2
    xz
    libsamplerate
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    intltool
    gobject-introspection
    vala
  ];

  propagatedBuildInputs = [
    pcre
    util-linux
    libselinux
    libsepol
  ];

  meta = {
    maintainers = with lib.maintainers; [ bendlas ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    description = "CD-ROM image access library";
    homepage = "https://cdemu.sourceforge.io/about/libmirage/";
  };
}
