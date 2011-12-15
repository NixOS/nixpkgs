{stdenv, fetchurl, ocaml, findlib, gdome2, ocaml_expat, gmetadom, ocaml_http, lablgtk, lablgtkmathview, ocaml_mysql, ocaml_sqlite3, ocamlnet, ulex08, camlzip, ocaml_pcre }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.5.8";
  pname = "matita";

in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://matita.cs.unibo.it/FILES/${pname}-${version}.orig.tar.gz";
    sha256 = "04sxklfak71khy1f07ks5c6163jbpxv6fmaw03fx8gwwlvpmzglh";
  };

  buildInputs = [ocaml findlib gdome2 ocaml_expat gmetadom ocaml_http lablgtk lablgtkmathview ocaml_mysql ocaml_sqlite3 ocamlnet ulex08 camlzip ocaml_pcre ];

  postPatch = ''
    BASH=$(type -tp bash)
    substituteInPlace components/Makefile --replace "SHELL=/bin/bash" "SHELL=$BASH"
    substituteInPlace matita/Makefile --replace "SHELL=/bin/bash" "SHELL=$BASH"
    substituteInPlace configure --replace "ulex08" "ulex"
    substituteInPlace components/METAS/meta.helm-content_pres.src --replace "ulex08" "ulex"
    substituteInPlace components/content_pres/Makefile --replace "ulex08" "ulex"
    substituteInPlace components/METAS/meta.helm-grafite_parser.src --replace "ulex08" "ulex"
    substituteInPlace components/grafite_parser/Makefile --replace "ulex08" "ulex"
    substituteInPlace configure --replace "zip" "camlzip"
    substituteInPlace components/METAS/meta.helm-getter.src --replace "zip" "camlzip"
    substituteInPlace components/METAS/meta.helm-xml.src --replace "zip" "camlzip"
  '';

  patches = [ ./configure.patch ./Makefile.patch ];

  preConfigure = ''
    # Setup for findlib.
    OCAMLPATH=$(pwd)/components/METAS:$OCAMLPATH
    RTDIR=$out/share/matita
    export configureFlags="--with-runtime-dir=$RTDIR"
  '';

  postInstall = ''
    ensureDir $out/bin
    ln -vs $RTDIR/matita $RTDIR/matitac $RTDIR/matitaclean $RTDIR/matitadep $RTDIR/matitawiki $out/bin
  '';

  meta = {
    homepage = http://matita.cs.unibo.it/;
    description = "Matita is an experimental, interactive theorem prover";
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
