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
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmirage";
  version = "3.2.10";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/libmirage-${finalAttrs.version}.tar.xz";
    hash = "sha256-+T5Gu3VcprCkSJcq/kTySRnNI7nc+GbRtctLkzPhgK4=";
  };

  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "out"}/share/gir-1.0";
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";
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
    description = "Suite of tools for emulating optical drives and discs";
    longDescription = ''
      CDEmu consists of:

      - a kernel module implementing a virtual drive-controller
      - libmirage which is a software library for interpreting optical disc images
      - a daemon which emulates the functionality of an optical drive+disc
      - textmode and GTK clients for controlling the emulator
      - an image analyzer to view the structure of image files

      Optical media emulated by CDemu can be mounted within Linux. Automounting is also allowed.
    '';
    homepage = "https://cdemu.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bendlas ];
  };
})
