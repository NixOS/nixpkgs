{stdenv, xenserver-buildroot, fetchurl, forkexecd, libffi, libuuid, message-switch, ocaml, omake, pam, python, tetex, utop, xen, zlib, camlp4, cdrom, cmdliner, fd-send-recv, findlib, nbd, netdev, oclock, opasswd, ounit, rpc, rrdd-plugin, ssl, stdext, tapctl, tar, xcp-idl, xcp-inventory, xcp-rrd, xen-api-client, xen-api-libs-transitional, xenstore, xenstore-clients, uri, re, cohttp, libev}:

stdenv.mkDerivation {
  name = "xapi-1.9.58";
  version = "1.9.58";

  src = fetchurl {
    url = "https://github.com/xapi-project/xen-api/archive/v1.9.58/xen-api-1.9.58.tar.gz";
    sha256 = "04qr7sa9d21i4ji82v7zy7a37m1n7nx0fww4y8iqqig2k9nxbmcd";
  };

  patches = [ "${xenserver-buildroot}/usr/share/buildroot/SOURCES/xen-api-sm-path-fix.patch" ./ocamlpath.patch ./version.patch ];

  buildInputs = [ forkexecd libffi libuuid message-switch ocaml omake pam python tetex utop zlib camlp4 cdrom cmdliner fd-send-recv findlib nbd netdev oclock opasswd ounit rpc rrdd-plugin ssl stdext tapctl tar xcp-idl xcp-inventory xcp-rrd xen-api-client xen-api-libs-transitional xenstore xenstore-clients uri re cohttp xen libev ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xen-api-xapi-conf.in xen-api-xapi-conf.in
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xen-api-init xen-api-init
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xen-api-xapissl xen-api-xapissl
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xen-api-db-conf xen-api-db-conf
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xen-api-pam xen-api-pam

    sh configure --bindir=$out/bin --etcdir=$out/etc --libexecdir=$out/libexec/xapi --xapiconf=$out/etc/xapi.conf --hooksdir=$out/etc/xapi/hook-scripts --sharedir=$out/usr/share/xapi --plugindir=$out/lib/xapi/plugins --optdir=$out/lib/xapi --disable-tests
    '';

  buildPhase = ''
    #export XEN_ROOT=${xen}
    #export DESTDIR=$out
    make

    sed -e "s|@LIBEXECDIR@|libexec|g" xen-api-xapi-conf.in > xen-api-xapi-conf
    sed -i -e "s|@LIBDIR@|lib|g" xen-api-xapi-conf
    '';

  installPhase = ''
    mkdir -p $out/sbin
    install -m 0755 ocaml/xapi/xapi.opt $out/sbin/xapi
    mkdir -p $out/etc/pam.d
    install -m 0644 xen-api-pam $out/etc/pam.d/xapi
    mkdir -p $out/etc/init.d
    install -m 0755 xen-api-init $out/etc/init.d/xapi
    mkdir -p $out/libexec/xapi
    install -m 0755 xen-api-xapissl $out/libexec/xapi/xapissl
    install -m 0755 scripts/update-mh-info $out/libexec/xapi/update-mh-info
    mkdir -p $out/etc/xapi
    install -m 0644 xen-api-xapi-conf $out/etc/xapi.conf
    install -m 0644 xen-api-db-conf $out/etc/xapi/db.conf

    mkdir -p $out/bin
    install -m 0755 ocaml/xe-cli/xe.opt $out/bin/xe
    mkdir -p $out/etc/bash_completion.d
    install -m 0755 ocaml/xe-cli/bash-completion $out/etc/bash_completion.d/xe

    mkdir -p $out/var/lib/xapi
    mkdir -p $out/etc/xapi/hook-scripts

    mkdir -p $out/etc/xcp
    echo master > $out/etc/xcp/pool.conf

    mkdir -p $out/usr/share/xapi/packages/iso

    mkdir -p $out/lib/${python.libPrefix}/site-packages
    install -m 0644 scripts/examples/python/XenAPI.py $out/lib/${python.libPrefix}/site-packages
    install -m 0644 scripts/examples/python/XenAPIPlugin.py $out/lib/${python.libPrefix}/site-packages
    install -m 0644 scripts/udhcpd.skel $out/etc/xcp/udhcpd.skel
    '';

  meta = {
    homepage = http://www.xen.org;
    description = "Xen toolstack for XCP";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
