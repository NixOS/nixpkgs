{
  stdenv,
  callPackage,
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
}:

let
  inherit
    (callPackage ./common-drv-attrs.nix {
      version = "3.3.1";
      pname = "libmirage";
      hash = "sha256-mstOGdmKJXRUrQA5F1DZGqVuY+f25Q5ZpdOXPx4MZRI=";
    })
    pname
    version
    src
    meta
    ;
in
stdenv.mkDerivation {
  inherit pname version src;

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
    inherit (meta)
      maintainers
      license
      platforms
      ;
    description = "CD-ROM image access library";
    homepage = "https://cdemu.sourceforge.io/about/libmirage/";
  };
}
