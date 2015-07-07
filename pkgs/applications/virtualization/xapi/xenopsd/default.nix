{stdenv, xenserver-buildroot, fetchurl, forkexecd, libvirt, ocaml, xen, cmdliner, cohttp, findlib, libvirt, oclock, qmp, rpc, sexplib, uuidm, uutf, xcp-idl, xcp-inventory, xcp-rrd, xenstore, xenstore-clients, message-switch, lwt}:

stdenv.mkDerivation {
  name = "xenopsd-0.9.46";
  version = "0.9.46";

  src = fetchurl {
    url = "https://github.com/xapi-project/xenopsd/archive/v0.9.46/xenopsd-0.9.46.tar.gz";
    sha256 = "0ig6kvfcx09iz459a6i5q2rvxs7inzrmy0f9fdsag9x2bskdlyxg";
  };

  patches = [ "${xenserver-buildroot}/usr/share/buildroot/SOURCES/xenopsd-32a56a1a800fe9d1e917a986734baac695776152" ];

  buildInputs = [ forkexecd libvirt ocaml cmdliner cohttp findlib libvirt oclock qmp rpc sexplib uuidm uutf xcp-idl xcp-inventory xcp-rrd xenstore xenstore-clients message-switch lwt xen ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xenopsd-xc-init xenopsd-xc-init
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xenopsd-simulator-init xenopsd-simulator-init
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xenopsd-libvirt-init xenopsd-libvirt-init
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xenopsd-xenlight-init xenopsd-xenlight-init
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/make-xsc-xenopsd.conf make-xsc-xenopsd.conf
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xenopsd-network-conf xenopsd-network-conf
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xenopsd-vncterm-wrapper xenopsd-vncterm-wrapper

    sh configure --libexecdir libexec/xenopsd
    '';

  buildPhase = ''
    make
    '';

  installPhase = ''
    mkdir -p $out/sbin
    install -D _build/libvirt/xenops_libvirt_main.native     $out/sbin/xenopsd-libvirt
    install -D _build/simulator/xenops_simulator_main.native $out/sbin/xenopsd-simulator
    install -D _build/xc/xenops_xc_main.native               $out/sbin/xenopsd-xc
    install -D _build/xl/xenops_xl_main.native               $out/sbin/xenopsd-xenlight

    mkdir -p $out/libexec/xenopsd
    install -D scripts/vif $out/libexec/xenopsd/vif
    install -D scripts/vif-real $out/libexec/xenopsd/vif-real
    install -D scripts/block $out/libexec/xenopsd/block
    install -D scripts/qemu-dm-wrapper $out/libexec/xenopsd/qemu-dm-wrapper
    install -D xenopsd-vncterm-wrapper $out/libexec/xenopsd/vncterm-wrapper
    install -D scripts/qemu-vif-script $out/libexec/xenopsd/qemu-vif-script
    install -D scripts/setup-vif-rules $out/libexec/xenopsd/setup-vif-rules
    install -D scripts/common.py $out/libexec/xenopsd/common.py
    install -D scripts/network.conf $out/libexec/xenopsd/network.conf

    mkdir -p $out/etc/init.d
    install -D -m 0755 xenopsd-xenlight-init $out/etc/init.d/xenopsd-xenlight
    install -m 0755 xenopsd-libvirt-init $out/etc/init.d/xenopsd-libvirt
    install -m 0755 xenopsd-xc-init $out/etc/init.d/xenopsd-xc
    install -m 0755 xenopsd-simulator-init $out/etc/init.d/xenopsd-simulator


    mkdir -p $out/etc/xapi
    chmod 755 make-xsc-xenopsd.conf
    LIBEXECDIR=libexec/xenopsd ETCDIR=$out/etc/xapi SCRIPTSDIR=libexec/xenopsd DESTDIR=$out ./make-xsc-xenopsd.conf > xenopsd-conf
    install -m 0644 xenopsd-conf $out/etc/xenopsd.conf
    install -m 0644 xenopsd-network-conf $out/etc/xapi/network.conf
    '';

  meta = {
    homepage = https://github.com/xapi-project/xenopsd;
    description = "Simple VM manager";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
