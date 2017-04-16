{stdenv, xenserver-buildroot, fetchurl, forkexecd, ocaml, xen, camlp4, findlib, oclock, rpc, rrd-transport, xcp-idl, xcp-inventory, xcp-rrd, xen-api-libs-transitional, xenops, uri, re, cohttp, message-switch, xenstore-clients, xenstore, libev}:

stdenv.mkDerivation {
  name = "xcp-rrdd-0.9.9";
  version = "0.9.9";

  src = fetchurl {
    url = "https://github.com/xapi-project/xcp-rrdd/archive/v0.9.9/xcp-rrdd-0.9.9.tar.gz";
    sha256 = "0zl0px7lmnxcz7344qdq7apz0hsjc07gif67jfsmgp04mmwr3kn0";
  };

  buildInputs = [ forkexecd ocaml camlp4 findlib oclock rpc rrd-transport xcp-idl xcp-inventory xcp-rrd xen-api-libs-transitional xenops uri re cohttp message-switch xenstore-clients xenstore xen libev ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-rrdd-init xcp-rrdd-init
    '';

  buildPhase = ''
    make
    '';

  installPhase = ''
    mkdir -p $out/sbin
    make install DESTDIR=$out SBINDIR=/sbin
    mkdir -p $out/etc/init.d
    install -m 0755 xcp-rrdd-init $out/etc/init.d/xcp-rrdd
    '';

  meta = {
    homepage = https://github.com/xapi-project/xcp-rrdd;
    description = "Statistics gathering daemon for the xapi toolstack";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
