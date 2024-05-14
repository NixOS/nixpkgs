{ callPackage, gobject-introspection, cmake, pkg-config
, glib, libsndfile, zlib, bzip2, xz, libsamplerate, intltool
, pcre, util-linux, libselinux, libsepol }:

callPackage ./base.nix {
  version = "3.2.7";
  pname = "libmirage";
  sha256 = "sha256-+okkgNeVS8yoKSrQDy4It7PiPlTSiOsUoFxQ1FS9s9M=";
  buildInputs = [ glib libsndfile zlib bzip2 xz libsamplerate ];
  extraDrvParams = {
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "out"}/share/gir-1.0";
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";
    nativeBuildInputs = [ cmake gobject-introspection pkg-config intltool ];
    propagatedBuildInputs = [ pcre util-linux libselinux libsepol ];
  };
}
