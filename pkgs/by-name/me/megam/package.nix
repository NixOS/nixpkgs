{
  lib,
  stdenv,
  fetchurl,
  ocaml-ng,
  ncurses,
}:

let
  inherit (ocaml-ng.ocamlPackages_4_14) ocaml;
in

stdenv.mkDerivation {
  pname = "megam";
  version = "0.92";

  src = fetchurl {
    url = "http://hal3.name/megam/megam_src.tgz";
    hash = "sha256-3A6fWf+FE0Sf471AsmAUH4nIik7fbdyLijlMdY5Jck4=";
  };

  patches = [
    ./ocaml-includes.patch
    ./ocaml-3.12.patch
  ];

  postPatch = ''
    # Deprecated in ocaml 3.10 https://github.com/ocaml/ocaml/commit/f6190f3d0c49c5220d443ee8d03ca5072d68aa87
    # Deprecated in ocaml 3.08 https://github.com/ocaml/ocaml/commit/0c7aecb88dc696f66f49f3bed54a037361a26b8d
    substituteInPlace fastdot_c.c --replace-fail copy_double caml_copy_double --replace-fail Bigarray_val Caml_ba_array_val --replace-fail caml_bigarray caml_ba_array
    # They were already deprecated in 3.12 https://v2.ocaml.org/releases/3.12/htmlman/libref/Array.html
    substituteInPlace abffs.ml main.ml --replace-fail create_matrix make_matrix
    substituteInPlace intHashtbl.ml --replace-fail Array.create Array.make
  '';
  strictDeps = true;
  __structuredAttrs = true;

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

  meta = {
    description = "MEGA Model Optimization Package";
    longDescription = ''
      The software here is an implementation of maximum likelihood and maximum a
      posterior optimization of the parameters of these models. The algorithms
      used are much more efficient than the iterative scaling techniques used in
      almost every other maxent package out there.
    '';
    homepage = "http://www.umiacs.umd.edu/~hal/megam";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ leixb ];
    platforms = lib.platforms.unix;
  };
}
