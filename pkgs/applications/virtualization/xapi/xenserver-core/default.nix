{stdenv, xenserver-buildroot, fetchurl}:

stdenv.mkDerivation {
  name = "xenserver-core-0.10.0";
  version = "0.10.0";

  unpackPhase = "true";

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xenserver-readme xenserver-readme
    '';

  buildPhase = "true";


  installPhase = ''
    mkdir -p $out/usr/share/doc/xenserver
    install -m 0644 xenserver-readme $out/usr/share/doc/xenserver/README
    '';

  meta = {
    homepage = http://www.xenserver.org/;
    description = "A virtual package which installs the xapi toolstack";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
