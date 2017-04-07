{ stdenv, fetchurl, fetchpatch, pkgconfig
, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXcursor, libXrandr, libXinerama, libXext, harfbuzz, mesa }:

stdenv.mkDerivation rec {
  version = "1.10a";
  name = "mupdf-${version}";

  src = fetchurl {
    url = "http://mupdf.com/downloads/archive/${name}-source.tar.gz";
    sha256 = "0dm8wcs8i29aibzkqkrn8kcnk4q0kd1v66pg48h5c3qqp4v1zk5a";
  };

  patches = [
    # Compatibility with new openjpeg
    (fetchpatch {
      name = "mupdf-1.9a-openjpeg-2.1.1.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/mupdf/trunk/0001-mupdf-openjpeg.patch?id=5a28ad0a8999a9234aa7848096041992cc988099";
      sha256 = "1i24qr4xagyapx4bijjfksj4g3bxz8vs5c2mn61nkm29c63knp75";
    })

    (fetchurl {
      name = "CVE-2017-5896.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=2c4e5867ee699b1081527bc6c6ea0e99a35a5c27";
      sha256 = "14k7x47ifx82sds1c06ibzbmcparfg80719jhgwjk6w1vkh4r693";
    })
  ];

  makeFlags = [ "prefix=$(out)" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib libX11 libXcursor libXext harfbuzz mesa libXrandr libXinerama freetype libjpeg jbig2dec openjpeg ];
  outputs = [ "bin" "dev" "out" "doc" ];

  preConfigure = ''
    # Don't remove mujs because upstream version is incompatible
    rm -rf thirdparty/{curl,freetype,glfw,harfbuzz,jbig2dec,jpeg,openjpeg,zlib}
  '';

  postInstall = ''
    for i in $out/lib/*.a; do
      so="''${i%.a}.so"
      gcc -shared -o $so.${version} -Wl,--whole-archive $i -Wl,--no-whole-archive
      ln -s $so.${version} $so
      rm $i
    done

    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/mupdf.pc" <<EOF
    prefix=$out
    libdir=$out/lib
    includedir=$out/include

    Name: mupdf
    Description: Library for rendering PDF documents
    Version: ${version}
    Libs: -L$out/lib -lmupdf -lmupdfthird
    Cflags: -I$dev/include
    EOF

    moveToOutput "bin" "$bin"
    mkdir -p $bin/share/applications
    cat > $bin/share/applications/mupdf.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=mupdf
    Comment=PDF viewer
    Exec=$bin/bin/mupdf-x11 %f
    Terminal=false
    EOF
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://mupdf.com;
    repositories.git = git://git.ghostscript.com/mupdf.git;
    description = "Lightweight PDF viewer and toolkit written in portable C";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric vrthra fpletz ];
    platforms = platforms.linux;
  };
}
