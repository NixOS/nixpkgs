{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "megam";
  version = "0.92";

  src = fetchurl {
    url = "http://hal3.name/megam/megam_src.tgz";
    sha256 = "dc0e9f59ff8513449fe3bd40b260141f89c88a4edf6ddc8b8a394c758e49724e";
  };

  patches = [
    ./ocaml-includes.patch
    ./ocaml-3.12.patch
  ];

  postPatch = ''
    # Deprecated in ocaml 3.10 https://github.com/ocaml/ocaml/commit/f6190f3d0c49c5220d443ee8d03ca5072d68aa87
    # Deprecated in ocaml 3.08 https://github.com/ocaml/ocaml/commit/0c7aecb88dc696f66f49f3bed54a037361a26b8d
    substituteInPlace fastdot_c.c --replace copy_double caml_copy_double --replace Bigarray_val Caml_ba_array_val --replace caml_bigarray caml_ba_array
    # They were already deprecated in 3.12 https://v2.ocaml.org/releases/3.12/htmlman/libref/Array.html
    substituteInPlace abffs.ml main.ml --replace create_matrix make_matrix
    substituteInPlace intHashtbl.ml --replace Array.create Array.make
  '';
  strictDeps = true;

  nativeBuildInputs = [ ocaml ];

  buildInputs = [ ncurses ];

  makeFlags = [
    "CAML_INCLUDES=${ocaml}/lib/ocaml/caml"
    ("WITHBIGARRAY=" + lib.optionalString (lib.versionOlder ocaml.version "4.08.0") "bigarray.cma")
    "all"
    "opt"
  ];

  # see https://bugzilla.redhat.com/show_bug.cgi?id=435559
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 megam $out/bin/megam
    install -Dm755 megam.opt $out/bin/megam.opt

    runHook postInstall
  '';

  meta = with lib; {
    description = "MEGA Model Optimization Package";
    longDescription = ''
      The software here is an implementation of maximum likelihood and maximum a
      posterior optimization of the parameters of these models. The algorithms
      used are much more efficient than the iterative scaling techniques used in
      almost every other maxent package out there.
    '';
    homepage = "http://www.umiacs.umd.edu/~hal/megam";
    license = "non-commercial";
    maintainers = with maintainers; [ leixb ];
    platforms = platforms.unix;
  };
}
