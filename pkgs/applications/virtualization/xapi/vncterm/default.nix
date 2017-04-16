{stdenv, fetchurl, xenserver-buildroot, xen}:

stdenv.mkDerivation {
  name = "vncterm-0.9.0";
  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/xenserver/vncterm/archive/0.9.0/vncterm-0.9.0.tar.gz";
    sha256 = "0kvng5iqfmi7m9q08h16g4x4niv6389bzl6jds38rf19zxrr0i1y";
  };

  patches = [ "${xenserver-buildroot}/usr/share/buildroot/SOURCES/vncterm-1-fix-build" ];

  buildInputs = [ xen ];

  configurePhase = "true";

  buildPhase = ''
    make
    '';


  installPhase = ''
    mkdir -p $out/bin/
    cp vncterm $out/bin/
    '';

  meta = {
    homepage = https://github.com/xenserver/vncterm;
    description = "TTY to VNC utility";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
