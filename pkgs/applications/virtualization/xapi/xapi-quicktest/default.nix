{stdenv, fetchurl, ocaml, camlp4, cmdliner, evtchn, findlib, gnt, ipaddr, lwt, testvmlib, vchan, xen-api-client, xenstore, xenstore-clients, mirage-types, libev, xen}:

stdenv.mkDerivation {
  name = "xapi-quicktest-0.0.0";
  version = "0.0.0";

  src = fetchurl {
    url = "https://github.com/xapi-project/quicktest/archive/v0.0.0/xapi-quicktest-0.0.0.tar.gz";
    sha256 = "1d7bfcglp7w5p3w85m54n8j1p0dfvjydpnsgdb4f0vji46bq2apv";
  };

  buildInputs = [ ocaml camlp4 cmdliner evtchn findlib gnt ipaddr lwt testvmlib vchan xen-api-client xenstore xenstore-clients mirage-types libev xen ];

  configurePhase = "true";

  buildPhase = ''
    make
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp quicktest.native $out/bin
    '';

  meta = {
    homepage = https://github.com/xapi-project/quicktest;
    description = "Simple xapi-project test suite";
    license = stdenv.lib.licenses.isc;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
