{stdenv, xenserver-buildroot, fetchurl, ocaml, async, camlp4, cmdliner, cohttp, findlib, re, rpc, lwt, libev}:

stdenv.mkDerivation {
  name = "message-switch-0.10.4";
  version = "0.10.4";

  src = fetchurl {
    url = "https://github.com/djs55/message-switch/archive/v0.10.4/message-switch-0.10.4.tar.gz";
    sha256 = "172asdvdz1dbsxr0k78qam7caj5119g8c60w4fwz60hz8l8c2bm6";
  };

  buildInputs = [ ocaml async camlp4 cmdliner findlib re rpc lwt libev ];

  propagatedBuildInputs = [ cohttp ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/message-switch-init message-switch-init
    ocaml setup.ml -configure
    '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    ocaml setup.ml -install

    mkdir -p $out/sbin
    install switch_main.native $out/sbin/message-switch
    install main.native $out/sbin/message-cli
    mkdir -p $out/etc/init.d
    install -m 0755 message-switch-init $out/etc/init.d/message-switch
    '';

  meta = {
    homepage = https://github.com/djs55/message-switch;
    description = "A store and forward message switch";
    license = stdenv.lib.licenses.bsd2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
