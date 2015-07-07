{stdenv, xenserver-buildroot, fetchurl, makeWrapper, forkexecd, libffi, ocaml, findlib, netlink, ounit, rpc, stdext, xcp-idl, xcp-inventory, xen-api-client, xen-api-libs-transitional, uri, re, cohttp, message-switch, libnl}:

stdenv.mkDerivation {
  name = "xcp-networkd-0.9.5";
  version = "0.9.5";

  src = fetchurl {
    url = "https://github.com/xapi-project/xcp-networkd/archive/v0.9.5/xcp-networkd-0.9.5.tar.gz";
    sha256 = "0gl61621fv4gdcrfb9i94sbjb1znz4h5zwv3ib5v7b5kl2fpav8x";
  };

  buildInputs = [ makeWrapper forkexecd libffi ocaml findlib netlink ounit rpc stdext xcp-idl xcp-inventory xen-api-client xen-api-libs-transitional uri re cohttp message-switch libnl];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-networkd-init xcp-networkd-init
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-networkd-conf xcp-networkd-conf
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-networkd-network-conf xcp-networkd-network-conf
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-networkd-bridge-conf xcp-networkd-bridge-conf
    '';

  buildPhase = ''
    export LD_LIBRARY_PATH=${libnl}/lib
    make
    '';

  installPhase = ''
    mkdir -p $out/sbin
    mkdir -p $out/bin
    make install DESTDIR=$out BINDIR=/bin SBINDIR=/sbin
    mkdir -p $out/etc/init.d
    install -m 0755 xcp-networkd-init $out/etc/init.d/xcp-networkd
    mkdir -p $out/etc/xcp
    install -m 0644 xcp-networkd-network-conf $out/etc/xcp/network.conf
    install -m 0644 xcp-networkd-conf $out/etc/xcp-networkd.conf
    mkdir -p $out/etc/modprobe.d
    install -m 0644 xcp-networkd-bridge-conf $out/etc/modprobe.d/bridge.conf
    mkdir -p $out/share/man/man1
    cp xcp-networkd.1 $out/share/man/man1/xcp-networkd.1
    gzip $out/share/man/man1/xcp-networkd.1

    wrapProgram $out/sbin/xcp-networkd \
        --prefix LD_LIBRARY_PATH ":" "${libnl}/lib"
    '';

  meta = {
    homepage = https://github.com/xapi-project/xcp-networkd;
    description = "Simple host network management service for the xapi toolstack";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
