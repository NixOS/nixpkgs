{ callPackage, gobject-introspection, cmake, pkg-config
, glib, libsndfile, zlib, bzip2, xz, libsamplerate, intltool
, pcre, util-linux, libselinux, libsepol }:

let pkg = import ./base.nix {
  version = "3.2.5";
  pname = "libmirage";
  pkgSha256 = "0f8i2ha44rykkk3ac2q8zsw3y1zckw6qnf6zvkyrj3qqbzhrf3fm";
};
in callPackage pkg {
  buildInputs = [ glib libsndfile zlib bzip2 xz libsamplerate ];
  drvParams = {
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "out"}/share/gir-1.0";
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";
    nativeBuildInputs = [ cmake gobject-introspection pkg-config intltool ];
    propagatedBuildInputs = [ pcre util-linux libselinux libsepol ];
  };
}
