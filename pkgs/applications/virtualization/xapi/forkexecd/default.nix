{stdenv, xenserver-buildroot, fetchurl, ocaml, fd-send-recv, cmdliner, findlib, re, rpc, stdext, uuidm, xcp-idl, uri, cohttp, message-switch, xcp-inventory}:

stdenv.mkDerivation {
  name = "forkexecd-0.9.2";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/xapi-project/forkexecd/archive/0.9.2/forkexecd-0.9.2.tar.gz";
    sha256 = "0f287brfs7g26myd6dvdb0pjyixfkkgs5wv83ljaxw41402pk1l0";
  };

  buildInputs = [ ocaml fd-send-recv findlib re stdext uri cohttp message-switch xcp-inventory ];

  propagatedBuildInputs = [ cmdliner rpc uuidm xcp-idl ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/forkexecd-init forkexecd-init
    ocaml setup.ml -configure
    '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    ocaml setup.ml -install

    mkdir -p $out/sbin
    install fe_main.native $out/sbin/forkexecd
    install fe_cli.native $out/sbin/forkexecd-cli
    mkdir -p $out/etc/init.d
    install -m 0755 forkexecd-init $out/etc/init.d/forkexecd
    '';

  meta = {
    homepage = https://github.com/xapi-project/forkexecd;
    description = "A subprocess management service";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
