{stdenv, fetchurl, ocaml, camlp4, cohttp, cstruct, evtchn, findlib, gnt, io-page, ipaddr, lwt, mirage-block-xen, mirage-clock-xen, mirage-console-xen, mirage-types, mirage-xen, rpc, shared-memory-ring, testvmlib, vchan, xenstore, xenstore-clients}:

stdenv.mkDerivation {
  name = "mirage-testvm-0.2";
  version = "0.2";

  src = fetchurl {
    url = "https://github.com/mirage/xen-testvm/archive/v0.2/mirage-testvm-0.2.tar.gz";
    sha256 = "0sjhr0064hbas8ygz83hg2850gy6zwk10n8g3rjiwg48jh888gnd";
  };

  buildInputs = [ ocaml camlp4 cohttp cstruct evtchn findlib gnt io-page ipaddr lwt mirage-block-xen mirage-clock-xen mirage-console-xen mirage-types mirage-xen rpc shared-memory-ring testvmlib vchan xenstore xenstore-clients ];

  configurePhase = "true";

  buildPhase = ''
    ./manual-build.sh
    '';

  installPhase = ''
    mkdir -p $out/boot/guest
    cp mir-test.xen $out/boot/guest/mirage-testvm.xen
    '';

  meta = {
    homepage = https://github.com/mirage/xen-testvm;
    description = "Simple Mirage test VM";
    license = stdenv.lib.licenses.isc;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
