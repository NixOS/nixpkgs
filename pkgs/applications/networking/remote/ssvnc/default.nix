{ stdenv, fetchurl, imake, zlib, jdk, libX11, libXt, libXmu
, libXaw, libXext, libXpm, openjpeg, openssl, tcl, tk, perl }:

stdenv.mkDerivation rec {
  name = "ssvnc-${version}";
  version = "1.0.29";

  src = fetchurl {
    url = "mirror://sourceforge/ssvnc/${name}.src.tar.gz";
    sha256 = "74df32eb8eaa68b07c9693a232ebe42154617c7f3cbe1d4e68d3fe7c557d618d";
  };

  buildInputs = [ imake zlib jdk libX11 libXt libXmu libXaw libXext libXpm openjpeg openssl ];

  configurePhase = "makeFlags=PREFIX=$out";

  postInstall = ''
    sed -i -e 's|exec wish|exec ${tk}/bin/wish|' $out/lib/ssvnc/util/ssvnc.tcl
    sed -i -e 's|/usr/bin/perl|${perl}/bin/perl|' $out/lib/ssvnc/util/ss_vncviewer
  '';

  meta = {
    description = "VNC viewer that adds encryption security to VNC connections";
    homepage = "http://www.karlrunge.com/x11vnc/ssvnc.html";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
