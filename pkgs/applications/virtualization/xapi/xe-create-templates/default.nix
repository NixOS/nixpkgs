{stdenv, fetchurl, ocaml, camlp4, findlib, lwt, obuild, stdext, xcp-idl, xen-api-client, xen-api-libs-transitional, xmlm, xcp-inventory, uuidm, uri, sexplib, rpc, re, message-switch, cstruct, cohttp, cmdliner, libev}:

stdenv.mkDerivation {
  name = "xe-create-templates-0.9.3";
  version = "0.9.3";

  src = fetchurl {
    url = "https://github.com/xapi-project/xcp-guest-templates/archive/v0.9.3/xe-create-templates-0.9.3.tar.gz";
    sha256 = "02ka98yn2m1ls4idfl57wjzqm3i5x066av6kbl08j0ki0z27sflg";
  };

  buildInputs = [ ocaml camlp4 findlib lwt obuild stdext xcp-idl xen-api-client xen-api-libs-transitional xmlm xcp-inventory uuidm uri sexplib rpc re message-switch cstruct cohttp cmdliner libev ];

  configurePhase = ''
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

    obuild configure
    '';

  buildPhase = ''
    obuild build
    '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 dist/build/xe-create-templates/xe-create-templates $out/bin/
    '';

  meta = {
    homepage = https://github.com/xapi-project/xcp-guest-templates;
    description = "Creates default XenServer templates";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
