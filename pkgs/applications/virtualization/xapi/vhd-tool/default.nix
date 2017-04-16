{stdenv, xenserver-buildroot, fetchurl, ocaml, cmdliner, findlib, io-page, lwt, nbd, sha, tapctl, tar, vhd, xcp-idl, xenstore, xenstore-clients, uri, cohttp, re, message-switch, xcp-inventory, libev}:

stdenv.mkDerivation {
  name = "vhd-tool-0.7.5";
  version = "0.7.5";

  src = fetchurl {
    url = "https://github.com/xapi-project/vhd-tool/archive/v0.7.5/vhd-tool-0.7.5.tar.gz";
    sha256 = "0kqkfm24fm70mg0sdj4rhyvk5vfs51638p0vljjbm037rxbg3h9a";
  };

  buildInputs = [ ocaml cmdliner findlib io-page lwt nbd sha tapctl tar vhd xcp-idl xenstore xenstore-clients uri cohttp re message-switch xcp-inventory libev ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/vhd-tool-sparse_dd-conf vhd-tool-sparse_dd-conf
    ./configure --bindir $out/bin --libexecdir $out/libexec/xapi --etcdir $out/etc
    '';

  buildPhase = ''
    make
    '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec/xapi
    mkdir -p $out/etc
    make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/vhd-tool;
    description = "Command-line tools for manipulating and streaming .vhd format files";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
