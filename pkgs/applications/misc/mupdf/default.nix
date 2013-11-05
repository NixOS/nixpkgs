{ stdenv, fetchurl, pkgconfig, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXext }:
stdenv.mkDerivation rec {
  name = "mupdf-1.3";

  src = fetchurl {
    url = "http://mupdf.com/download/archive/${name}-source.tar.gz";
    sha256 = "0y247nka5gkr1ajn47jrlp5rcnf6h4ff7dfsprma3h4wxqdv7a5b";
  };

  buildInputs = [ pkgconfig zlib freetype libjpeg jbig2dec openjpeg libX11 libXext ];

  enableParallelBuilding = true;

  preBuild = ''
    export makeFlags="prefix=$out build=release"
    export NIX_CFLAGS_COMPILE=" $NIX_CFLAGS_COMPILE -I$(echo ${openjpeg}/include/openjpeg-*) "
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/mupdf.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=mupdf
    Comment=PDF viewer
    Exec=$out/bin/mupdf-x11
    Terminal=false
    EOF
  '';

  meta = {
    homepage = http://mupdf.com/;
    description = "Lightweight PDF viewer and toolkit written in portable C";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
