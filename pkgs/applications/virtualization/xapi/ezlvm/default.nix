{stdenv, fetchurl, ocaml, ocamlscript, xapi-storage, camlp4, cmdliner, findlib, ounit, re, uri, rpc}:

stdenv.mkDerivation {
  name = "ezlvm-0.3";
  version = "0.3";

  src = fetchurl {
    url = "https://github.com/xapi-project/ezlvm/archive/v0.3/ezlvm-0.3.tar.gz";
    sha256 = "00szpv5r68cva2mc9qar6q7d9ngvnkpnfib8gw3ac3jw0l6asnpc";
  };

  buildInputs = [ ocaml ocamlscript xapi-storage camlp4 cmdliner findlib ounit re uri rpc ];

  configurePhase = "true";

  buildPhase = ''
    ./volume/SR.ls --help=groff
    '';

  installPhase = ''
    cd volume
    DESTDIR=$out SCRIPTDIR=/libexec/xapi-storage-script/volume/org.xen.xcp.storage.ezlvm make install
    cd ../datapath
    DESTDIR=$out SCRIPTDIR=/libexec/xapi-storage-script/datapath/block make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/ezlvm;
    description = "Simple LVM storage adapter for xapi";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
