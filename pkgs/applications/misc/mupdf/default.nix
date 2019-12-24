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
  version = "1.16.1";
  pname = "mupdf";

  src = fetchurl {
    url = "https://mupdf.com/downloads/archive/${pname}-${version}-source.tar.gz";
    sha256 = "0iz4ickj52fxjp8crg573kjrl4viq279g589isdpgpckslysf7g7";
  };

  patches =
    # Use shared libraries to decrease size
    stdenv.lib.optional (!stdenv.isDarwin) ./mupdf-1.14-shared_libs.patch
    ++ stdenv.lib.optional stdenv.isDarwin ./darwin.patch
  ;

  postPatch = ''
    sed -i "s/__OPENJPEG__VERSION__/${openJpegVersion}/" source/fitz/load-jpx.c
  '';

  makeFlags = [ "prefix=$(out) USE_SYSTEM_LIBS=yes" ];
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
    Libs: -L$out/lib -lmupdf -lmupdf-third
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
    homepage = https://mupdf.com;
    repositories.git = git://git.ghostscript.com/mupdf.git;
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vrthra fpletz ];
    platforms = platforms.unix;
  };
}
