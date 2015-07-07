{stdenv, xenserver-buildroot, fetchurl, libvirt, ocaml, cmdliner, cohttp, findlib, libvirt, re, rpc, xcp-idl, message-switch, fd-send-recv, xcp-inventory}:

stdenv.mkDerivation {
  name = "xapi-libvirt-storage-0.9.8";
  version = "0.9.8";

  src = fetchurl {
    url = "https://github.com/xapi-project/xapi-libvirt-storage/archive/0.9.8/xapi-libvirt-storage-0.9.8.tar.gz";
    sha256 = "10qpbczvr03dc566zvnfrfqsc8zmxdg938r8da90428zscz52s1v";
  };

  buildInputs = [ libvirt ocaml cmdliner cohttp findlib libvirt re rpc xcp-idl message-switch fd-send-recv xcp-inventory ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xapi-libvirt-storage-init xapi-libvirt-storage-init
    '';

  buildPhase = ''
    make
    '';

  #createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $out/sbin
    install main.native $out/sbin/xapi-libvirt-storage
    mkdir -p $out/etc/init.d
    install -m 0755 xapi-libvirt-storage-init $out/etc/init.d/xapi-libvirt-storage
    '';

  meta = {
    homepage = https://github.com/xapi-project/xapi-libvirt-storage/archive/0.9.8.tar.gz;
    description = "Allows the manipulation of libvirt storage pools and volumes via xapi";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
