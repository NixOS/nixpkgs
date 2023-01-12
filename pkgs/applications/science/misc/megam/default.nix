{ fetchurl, lib, stdenv, ocaml, makeWrapper, ncurses }:

let version = "0.92"; in
stdenv.mkDerivation {
  pname = "megam";
  inherit version;

  src = fetchurl {
    url = "http://hal3.name/megam/megam_src.tgz";
    sha256 = "dc0e9f59ff8513449fe3bd40b260141f89c88a4edf6ddc8b8a394c758e49724e";
  };

  patches = [ ./ocaml-includes.patch ./ocaml-3.12.patch ];

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ocaml ];

  buildInputs = [ ncurses ];

  makeFlags = [
    "CAML_INCLUDES=${ocaml}/lib/ocaml/caml"
    "WITHBIGARRAY=bigarray.cma"
  ];

  # see https://bugzilla.redhat.com/show_bug.cgi?id=435559
  dontStrip = true;

  installPhase = ''
    mkdir -pv $out/bin
    cp -Rv megam $out/bin
  '';


  meta = {
    description = "MEGA Model Optimization Package";

    longDescription =
      ''  The software here is an implementation of maximum likelihood
          and maximum a posterior optimization of the parameters of
          these models.  The algorithms used are much more efficient
          than the iterative scaling techniques used in almost every
          other maxent package out there.  '';

    homepage = "http://www.umiacs.umd.edu/~hal/megam";

    license = "non-commercial";

    maintainers = [ ];
    platforms = lib.platforms.unix; # arbitrary choice
  };
}
