{ stdenv, fetchurl, fetchpatch, pkgconfig, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXext }:
stdenv.mkDerivation rec {
  version = "1.5";
  name = "mupdf-${version}";

  src = fetchurl {
    url = "http://mupdf.com/download/archive/${name}-source.tar.gz";
    sha256 = "0sl47zqf4c9fhs4h5zg046vixjmwgy4vhljhr5g4md733nash7z4";
  };

  buildInputs = [ pkgconfig zlib freetype libjpeg jbig2dec openjpeg libX11 libXext ];

  enableParallelBuilding = true;

  my_soname = "libmupdf.so.1.3";
  my_soname_js_none = "libmupdf-js-none.so.1.3";
  preBuild = ''
    export makeFlags="prefix=$out build=release XCFLAGS=-fpic"
    export NIX_CFLAGS_COMPILE=" $NIX_CFLAGS_COMPILE -I$(echo ${openjpeg}/include/openjpeg-*) "

    # Copied from Gentoo ebuild
    rm -rf thirdparty
    sed -e "\$a\$(MUPDF_LIB): \$(MUPDF_JS_NONE_LIB)" \
     -e "\$a\\\t\$(QUIET_LINK) \$(CC) \$(LDFLAGS) --shared -Wl,-soname -Wl,${my_soname} -Wl,--no-undefined -o \$@ \$^ \$(MUPDF_JS_NONE_LIB) \$(LIBS)" \
     -e "/^MUPDF_LIB :=/s:=.*:= \$(OUT)/${my_soname}:" \
     -e "\$a\$(MUPDF_JS_NONE_LIB):" \
     -e "\$a\\\t\$(QUIET_LINK) \$(CC) \$(LDFLAGS) --shared -Wl,-soname -Wl,${my_soname_js_none} -Wl,--no-undefined -o \$@ \$^ \$(LIBS)" \
     -e "/^MUPDF_JS_NONE_LIB :=/s:=.*:= \$(OUT)/${my_soname_js_none}:" \
     -i Makefile

    sed -e "s/libopenjpeg1/libopenjp2/" -i Makerules
  '';

  postInstall = ''
    ln -s ${my_soname} $out/lib/libmupdf.so

    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/mupdf.pc" <<EOF
    prefix=$out
    libdir=$out/lib
    includedir=$out/include

    Name: mupdf
    Description: Library for rendering PDF documents
    Requires: freetype2 libopenjp2 libcrypto
    Version: 1.3
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
    Exec=$out/bin/mupdf-x11
    Terminal=false
    EOF
  '';

  meta = {
    homepage = http://mupdf.com/;
    repositories.git = git://git.ghostscript.com/mupdf.git;
    description = "Lightweight PDF viewer and toolkit written in portable C";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
    inherit version;
  };
}
