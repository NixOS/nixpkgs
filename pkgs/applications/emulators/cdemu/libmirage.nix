{
  stdenv,
  callPackage,
  cmake,
  pkg-config,
  gobject-introspection,
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
}:

stdenv.mkDerivation {

  inherit
    (callPackage ./common-drv-attrs.nix {
      version = "3.2.7";
      pname = "libmirage";
      hash = "sha256-+okkgNeVS8yoKSrQDy4It7PiPlTSiOsUoFxQ1FS9s9M=";
    })
    pname
    version
    src
    meta
    ;

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
  ];
  propagatedBuildInputs = [
    pcre
    util-linux
    libselinux
    libsepol
  ];

}
