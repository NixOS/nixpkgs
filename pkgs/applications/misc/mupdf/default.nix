{ stdenv, lib, fetchurl, fetchpatch, pkgconfig
, freetype, harfbuzz, openjpeg, jbig2dec, libjpeg
, enableX11 ? true, libX11, libXext
, enableCurl ? true, curl, openssl
}:

stdenv.mkDerivation rec {
  version = "1.11";
  name = "mupdf-${version}";

  src = fetchurl {
    url = "http://mupdf.com/downloads/archive/${name}-source.tar.gz";
    sha256 = "02phamcchgsmvjnb3ir7r5sssvx9fcrscn297z73b82n1jl79510";
  };

  patches = [
    # Compatibility with new openjpeg
    (fetchpatch {
      name = "mupdf-1.11-openjpeg-2.1.1.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/0001-mupdf-openjpeg.patch?h=packages/mupdf&id=3d997e7ff2ac20c44856ede22760ba6fbca81a5c";
      sha256 = "1vr12kpzmmfr8pp3scwfhrm5laqwd58xm6vx971c4y8bxy60b2ig";
    })

    (fetchurl {
      name = "mupdf-1.11-CVE-2017-6060.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=blobdiff_plain;f=platform/x11/jstest_main.c;h=f158d9628ed0c0a84e37fe128277679e8334422a;hp=13c3a0a3ba3ff4aae29f6882d23740833c1d842f;hb=06a012a42c9884e3cd653e7826cff1ddec04eb6e;hpb=34e18d127a02146e3415b33c4b67389ce1ddb614";
      sha256 = "163bllvjrbm0gvjb25lv7b6sih4zr4g4lap3h0cbq8dvpjxx0jfc";
    })

    (fetchpatch {
      name = "mupdf-1.11-shared_libs-1.patch";
      url = "https://ftp.osuosl.org/pub/blfs/conglomeration/mupdf/mupdf-1.11-shared_libs-1.patch";
      sha256 = "127x8jhyj3i9cn3mxw9mm5barw2yk43rvmghg54bhn4rjalx857j";
    })
  ];

  makeFlags = [ "prefix=$(out)" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ freetype harfbuzz openjpeg jbig2dec libjpeg ]
                ++ lib.optionals enableX11 [ libX11 libXext ]
                ++ lib.optionals enableCurl [ curl openssl ];
  outputs = [ "bin" "dev" "out" "man" "doc" ];

  preConfigure = ''
    # Don't remove mujs because upstream version is incompatible
    rm -rf thirdparty/{curl,freetype,glfw,harfbuzz,jbig2dec,libjpeg,openjpeg,zlib}
  '';

  postInstall = ''
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
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric vrthra fpletz ];
    platforms = platforms.linux;
  };
}
