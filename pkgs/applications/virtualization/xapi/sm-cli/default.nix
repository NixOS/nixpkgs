{stdenv, fetchurl, ocaml, cmdliner, findlib, obuild, re, rpc, xcp-idl, xcp-inventory, uri, sexplib, message-switch, fd-send-recv, cohttp}:

stdenv.mkDerivation {
  name = "sm-cli-0.9.4";
  version = "0.9.4";

  src = fetchurl {
    url = "https://github.com/xapi-project/sm-cli/archive/0.9.4/sm-cli-0.9.4.tar.gz";
    sha256 = "0y0sr8m5h1y65mm35ism4c9c9v0v0abcqkzd6g9hi6wakm8l7laa";
  };

  buildInputs = [ ocaml cmdliner findlib obuild re rpc xcp-idl xcp-inventory uri sexplib message-switch fd-send-recv cohttp ];

  configurePhase = "true";

  buildPhase = ''
    cat << EOF >> findlib.conf
    destdir="$OCAMLFIND_DESTDIR"
    path="$OCAMLPATH"
    ldconf="ignore"
    ocamlc="ocamlc.opt"
    ocamlopt="ocamlopt.opt"
    ocamldep="ocamldep.opt"
    ocamldoc="ocamldoc.opt"
    EOF
    export OCAMLFIND_CONF=`pwd`/findlib.conf

    make
    '';

  #createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $out/sbin
    install dist/build/sm-cli/sm-cli $out/sbin/sm-cli
    '';

  meta = {
    homepage = https://github.com/xapi-project/sm-cli;
    description = "CLI for xapi toolstack storage managers";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
