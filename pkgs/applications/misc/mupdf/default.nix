{ stdenv, fetchurl, fetchpatch, pkgconfig
, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXcursor, libXrandr, libXinerama, libXext, harfbuzz, mesa }:

stdenv.mkDerivation rec {
  version = "1.9";
  name = "mupdf-${version}";

  src = fetchurl {
    url = "http://mupdf.com/downloads/archive/${name}-source.tar.gz";
    sha256 = "15p2k1n3afc7bnqrc0zfqz31fjfq3rrrrj4fwwy5az26d11ynxhp";
  };

  NIX_CFLAGS_COMPILE= [ "-fPIC" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib freetype libX11 libXcursor libXext harfbuzz mesa libXrandr libXinerama];

  installPhase = ''
    make install prefix=$out
    gcc -shared -o $out/lib/libmupdf.so.${version} -Wl,--whole-archive $out/lib/libmupdf.a -Wl,--no-whole-archive

    ln -s $out/lib/libmupdf.so.${version} $out/lib/libmupdf.so

    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/mupdf.pc" <<EOF
    prefix=$out
    libdir=$out/lib
    includedir=$out/include

    Name: mupdf
    Description: Library for rendering PDF documents
    Requires: freetype2 libopenjp2 libcrypto
    Version: ${version}
    Libs: -L$out/lib -lmupdf
    Cflags: -I$out/include
    EOF

    mkdir -p $out/share/applications
    cat > $out/share/applications/mupdf.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=mupdf
    Comment=PDF viewer
    Exec=$out/bin/mupdf-x11 %f
    Terminal=false
    EOF
  '';
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://mupdf.com;
    repositories.git = git://git.ghostscript.com/mupdf.git;
    description = "Lightweight PDF viewer and toolkit written in portable C";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric vrthra ];
    platforms = platforms.linux;
  };
}
