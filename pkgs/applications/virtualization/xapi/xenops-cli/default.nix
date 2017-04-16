{stdenv, fetchurl, ocaml, cmdliner, findlib, rpc, uuidm, xcp-idl, uri, re, cohttp, message-switch, fd-send-recv, xcp-inventory}:

stdenv.mkDerivation {
  name = "xenops-cli-0.9.1";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/xapi-project/xenops-cli/archive/xenops-cli-0.9.1/xenops-cli-0.9.1.tar.gz";
    sha256 = "0g8s5q1z05nak10sgsvkh7yxqb19rvdypab07i7nr7bf1aq9kci1";
  };

  buildInputs = [ ocaml cmdliner findlib rpc uuidm xcp-idl uri re cohttp message-switch fd-send-recv xcp-inventory ];

  configurePhase = "true";

  buildPhase = ''
    make
    '';

  #createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $out/sbin
    install main.native $out/sbin/xenops-cli
    '';

  meta = {
    homepage = https://github.com/xapi-project/xenops-cli;
    description = "CLI for xenopsd, the xapi toolstack domain manager";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
