{stdenv, xenserver-buildroot, fetchurl, message-switch, ocaml, xapiStorage, async-inotify, camlp4, findlib, rpc, xcp-idl, fd-send-recv, xcp-inventory}:

stdenv.mkDerivation {
  name = "xapi-storage-script-0.1.2";
  version = "0.1.2";

  src = fetchurl {
    url = "https://github.com/xapi-project/xapi-storage-script/archive/v0.1.2/xapi-storage-script-0.1.2.tar.gz";
    sha256 = "17why2kaln0cap81a46p1d84ayk25q47xxhisp1vh6pwyf8s7vi5";
  };

  buildInputs = [ message-switch ocaml xapi-storage async-inotify camlp4 findlib rpc xcp-idl fd-send-recv xcp-inventory ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xapi-storage-script-init xapi-storage-script-init
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xapi-storage-script-conf.in xapi-storage-script-conf.in
    '';

  buildPhase = ''
    make
    mv main.native xapi-storage-script
    ./xapi-storage-script --help=groff > xapi-storage-script.1
    sed -e "s|@LIBEXECDIR@|libexec|g" xapi-storage-script-conf.in > xapi-storage-script.conf
    '';

  #createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $out/sbin
    install -m 0755 xapi-storage-script $out/sbin/xapi-storage-script
    mkdir -p $out/etc/init.d
    install -m 0755 xapi-storage-script-init $out/etc/init.d/xapi-storage-script
    mkdir -p $out/libexec/xapi-storage-script
    mkdir -p $out/libexec/xapi-storage-script/volume
    mkdir -p $out/libexec/xapi-storage-script/datapath
    mkdir -p $out/etc
    install -m 0644 xapi-storage-script.conf $out/etc/xapi-storage-script.conf
    mkdir -p $out/share/man/man2
    install -m 0644 xapi-storage-script.1 $out/share/man/man2/xapi-storage-script.1
    gzip $out/share/man/man2/xapi-storage-script.1
    '';

  meta = {
    homepage = https://github.com/xapi-project/xapi-storage-script;
    description = "Xapi storage script plugin server";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
