{ stdenv, lib, fetchurl, fetchpatch, pkgconfig, freetype, harfbuzz, openjpeg
, jbig2dec, libjpeg , darwin
, enableX11 ? true, libX11, libXext, libXi, libXrandr
, enableCurl ? true, curl, openssl
, enableGL ? true, freeglut, libGLU
}:

let

  # OpenJPEG version is hardcoded in package source
  openJpegVersion = with stdenv;
    lib.concatStringsSep "." (lib.lists.take 2
      (lib.splitString "." (lib.getVersion openjpeg)));


in stdenv.mkDerivation rec {
  version = "1.12.0";
  name = "mupdf-${version}";

  src = fetchurl {
    url = "http://mupdf.com/downloads/archive/${name}-source.tar.gz";
    sha256 = "0mc7a92zri27lk17wdr2iffarbfi4lvrmxhc53sz84hm5yl56qsw";
  };

  patches = [
    # Compatibility with new openjpeg
    (fetchpatch {
      name = "mupdf-1.12-openjpeg-version.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/0001-mupdf-openjpeg.patch?h=packages/mupdf&id=a910cd33a2b311712f83710dc042fbe80c104306";
      sha256 = "05i9v2ia586jyjqdb7g68ss4vkfwgp6cwhagc8zzggsba83azyqk";
    })
    (fetchpatch {
      name = "CVE-2018-6544.1.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=commitdiff_plain;h=b03def134988da8c800adac1a38a41a1f09a1d89;hp=26527eef77b3e51c2258c8e40845bfbc015e405d";
      sha256 = "1rlmjibl73ls8xfpsz69axa3lw5l47vb0a1dsjqziszsld4lpj5i";
    })
    (fetchpatch {
      name = "CVE-2018-6544.2.patch";
      url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=26527eef77b3e51c2258c8e40845bfbc015e405d;hp=ab98356f959c7a6e94b1ec10f78dd2c33ed3f3e7";
      sha256 = "1brcc029s5zmd6ya0d9qk3mh9qwx5g6vhsf1j8h879092sya5627";
    })
  ]

  # Use shared libraries to decrease size
  ++ stdenv.lib.optional (!stdenv.isDarwin) ./mupdf-1.12-shared_libs-1.patch

  ++ stdenv.lib.optional stdenv.isDarwin ./darwin.patch
  ;

  postPatch = ''
    sed -i "s/__OPENJPEG__VERSION__/${openJpegVersion}/" source/fitz/load-jpx.c
  '';

  makeFlags = [ "prefix=$(out)" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ freetype harfbuzz openjpeg jbig2dec libjpeg freeglut libGLU ]
                ++ lib.optionals enableX11 [ libX11 libXext libXi libXrandr ]
                ++ lib.optionals enableCurl [ curl openssl ]
                ++ lib.optionals enableGL (
                  if stdenv.isDarwin then
                    with darwin.apple_sdk.frameworks; [ GLUT OpenGL ]
                  else
                    [ freeglut libGLU ])
                ;
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
    platforms = platforms.unix;
  };
}
