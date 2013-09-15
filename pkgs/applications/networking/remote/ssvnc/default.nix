{ stdenv, fetchurl, imake, zlib, openjdk, libX11, libXt, libXmu, libXaw, libXext, libXpm, openjpeg, openssl }:

let version = "1.0.29"; in
stdenv.mkDerivation rec {
  name = "ssvnc-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ssvnc/${name}.src.tar.gz";
    sha256 = "74df32eb8eaa68b07c9693a232ebe42154617c7f3cbe1d4e68d3fe7c557d618d";
  };

  buildInputs = [ imake zlib openjdk libX11 libXt libXmu libXaw libXext libXpm openjpeg openssl ];

  configurePhase = "makeFlags=PREFIX=$out";

  meta = {
    description = "VNC viewer that adds encryption security to VNC connections";
    homepage = "http://www.karlrunge.com/x11vnc/ssvnc.html";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
