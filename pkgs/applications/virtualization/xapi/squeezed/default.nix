{stdenv, xenserver-buildroot, fetchurl, ocaml, xen, cmdliner, findlib, re, rpc, stdext, uuidm, xcp-idl, xenstore, xenstore-clients, uri, cohttp, message-switch, xcp-inventory, lwt}:

stdenv.mkDerivation {
  name = "squeezed-0.10.6";
  version = "0.10.6";

  src = fetchurl {
    url = "https://github.com/xapi-project/squeezed/archive/0.10.6/squeezed-0.10.6.tar.gz";
    sha256 = "0gpjr39a6njnvqw3f7ivflk4dab0qzcrzr6jvjnmbibcrqdsajqs";
  };

  buildInputs = [ ocaml cmdliner findlib re rpc stdext uuidm xcp-idl xenstore xenstore-clients uri cohttp message-switch xcp-inventory lwt xen ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/squeezed-init squeezed-init
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/squeezed-conf squeezed-conf
    ./configure --prefix $out --destdir $out
    '';

  buildPhase = ''
    make
    '';

  installPhase = ''
    mkdir -p $out/sbin $out/etc $out/init.d
    install -D -m 0755 squeezed.native $out/sbin/squeezed
    install -D -m 0755 squeezed-init $out/etc/init.d/squeezed
    install -D -m 0644 squeezed-conf $out/etc/squeezed.conf
    '';

  meta = {
    homepage = https://github.com/xapi-project/squeezed;
    description = "Memory ballooning daemon for the xapi toolstack";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
