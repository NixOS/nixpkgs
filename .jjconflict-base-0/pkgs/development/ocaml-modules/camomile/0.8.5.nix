{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  ocaml,
  findlib,
  camlp4,
}:

stdenv.mkDerivation {
  pname = "camomile";
  version = "0.8.5";

  src = fetchurl {
    url = "https://github.com/yoriyuki/Camomile/releases/download/rel-0.8.5/camomile-0.8.5.tar.bz2";
    sha256 = "003ikpvpaliy5hblhckfmln34zqz0mk3y2m1fqvbjngh3h2np045";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/camomile/camomile.0.8.5/files/4.05-typing-fix.patch";
      sha256 = "167279lia6qx62mdcyc5rjsi4gf4yi52wn9mhgd9y1v3754z7fwb";
    })
  ];

  nativeBuildInputs = [
    ocaml
    findlib
    camlp4
  ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = {
    homepage = "https://github.com/yoriyuki/Camomile/tree/master/Camomile";
    description = "Comprehensive Unicode library for OCaml";
    license = lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [
      lib.maintainers.maggesi
    ];
  };
}
