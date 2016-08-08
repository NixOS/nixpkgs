{ stdenv, fetchurl, fetchpatch, pkgconfig
, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXcursor, libXrandr, libXinerama, libXext, harfbuzz, mesa }:

stdenv.mkDerivation rec {
  version = "1.9a";
  name = "mupdf-${version}";

  src = fetchurl {
    url = "http://mupdf.com/downloads/archive/${name}-source.tar.gz";
    sha256 = "1k64pdapyj8a336jw3j61fhn0rp4q6az7d0dqp9r5n3d9rgwa5c0";
  };

  patches = [
    # http://www.openwall.com/lists/oss-security/2016/08/03/2
    (fetchpatch {
      name = "mupdf-fix-CVE-2016-6525.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=commitdiff_plain;h=39b0f07dd960f34e7e6bf230ffc3d87c41ef0f2e;hp=fa1936405b6a84e5c9bb440912c23d532772f958";
      sha256 = "1g9fkd1f5rx1z043vr9dj4934qf7i4nkvbwjc61my9azjrrc3jv7";
    })
  ];

  NIX_CFLAGS_COMPILE= [ "-fPIC" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib freetype libX11 libXcursor libXext harfbuzz mesa libXrandr libXinerama ];

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
