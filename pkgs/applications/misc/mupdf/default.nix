{ stdenv, lib, fetchurl, fetchpatch, pkgconfig
, freetype, harfbuzz, openjpeg, jbig2dec, libjpeg
, enableX11 ? true, libX11, libXext
, enableCurl ? true, curl, openssl
}:

let

  # OpenJPEG version is hardcoded in package source
  openJpegVersion = with stdenv;
    lib.concatStringsSep "." (lib.lists.take 2
      (lib.splitString "." (lib.getVersion openjpeg)));


in stdenv.mkDerivation rec {
  version = "1.11";
  name = "mupdf-${version}";

  src = fetchurl {
    url = "http://mupdf.com/downloads/archive/${name}-source.tar.gz";
    sha256 = "02phamcchgsmvjnb3ir7r5sssvx9fcrscn297z73b82n1jl79510";
  };

  patches = [
    # Compatibility with new openjpeg
    (fetchpatch {
      name = "mupdf-1.11-openjpeg-version.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/0001-mupdf-openjpeg.patch?h=packages/mupdf&id=c19349f42838e4dca02e564b97e0a5ab3e1b943f";
      sha256 = "0sx7jq84sr8bj6sg2ahg9cdgqz8dh4w6r0ah2yil8vrsznn4la8r";
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

    (fetchurl {
      name = "mupdf-1.11-CVE-2017-14685.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=ab1a420613dec93c686acbee2c165274e922f82a";
      sha256 = "120xapwj0af333n3a32ypxk0jmjv2ia476jg8pzsfqk9a5qqkx46";
    })

    (fetchurl {
      name = "mupdf-1.11-CVE-2017-14686.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=0f0fbc07d9be31f5e83ec5328d7311fdfd8328b1";
      sha256 = "0pkn7mfqhmnsyia4rh4mw4q435bzvlc22crqa1bxpaa0gcyky51c";
    })

    (fetchurl {
      name = "mupdf-1.11-CVE-2017-14687.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=2b16dbd8f73269cb15ca61ece75cf8d2d196ed28";
      sha256 = "01v41cwrdnz3k32fcadk2gk4knqrm3mavzp6pxhn19nwgmqkshjd";
    })

    (fetchurl {
      name = "mupdf-1.11-CVE-2017-15587.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=82df2631d7d0446b206ea6b434ea609b6c28b0e8";
      sha256 = "04kfww7y0wazg6372g44fa2k5kiiigq4616ihkvmp18rz86903n9";
    })

    (fetchurl {
      name = "mupdf-1.11-CVE-2017-15369.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=c2663e51238ec8256da7fc61ad580db891d9fe9a";
      sha256 = "0xx2mrbjcymi3gh0l3cq81m6bygp9dv79v1kyrbcvpl5z6wgl71y";
    })
  ];

  postPatch = ''
    sed -i "s/__OPENJPEG__VERSION__/${openJpegVersion}/" source/fitz/load-jpx.c
  '';

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
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ viric vrthra fpletz ];
    platforms = platforms.linux;
  };
}
