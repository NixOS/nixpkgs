{stdenv, fetchurl, ocaml, findlib, gdome2, ocaml_expat, gmetadom, ocaml_http, lablgtk, ocaml_mysql, ocamlnet, ulex08, camlzip, ocaml_pcre, automake, autoconf }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.99.1pre130312";
  pname = "matita";

in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://matita.cs.unibo.it/sources/${pname}_130312.tar.gz"; 
    sha256 = "13mjvvldv53dcdid6wmc6g8yn98xca26xq2rgq2jg700lqsni59s";
  };

  sourceRoot="${pname}-${version}";

  unpackPhase = ''
   mkdir $sourceRoot
   tar -xvzf $src -C $sourceRoot
   echo "source root is $sourceRoot"
  '';

  prePatch = ''
   autoreconf -fvi 
  '';

  buildInputs = [ocaml findlib gdome2 ocaml_expat gmetadom ocaml_http lablgtk ocaml_mysql ocamlnet ulex08 camlzip ocaml_pcre automake autoconf];

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

  patches = [ ./configure_130312.patch ];

  preConfigure = ''
    # Setup for findlib.
    OCAMLPATH=$(pwd)/components/METAS:$OCAMLPATH
    RTDIR=$out/share/matita
    export configureFlags="--with-runtime-dir=$RTDIR"
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -vs $RTDIR/matita $RTDIR/matitac $RTDIR/matitaclean $RTDIR/matitadep $RTDIR/matitawiki $out/bin
  '';

  meta = {
    homepage = http://matita.cs.unibo.it/;
    description = "Matita is an experimental, interactive theorem prover";
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
