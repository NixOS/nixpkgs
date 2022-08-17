{ stdenv
, lib
, fetchurl
, fetchpatch
, copyDesktopItems
, makeDesktopItem
, desktopToDarwinBundle
, pkg-config
, freetype
, harfbuzz
, openjpeg
, jbig2dec
, libjpeg
, darwin
, gumbo
, enableX11 ? (!stdenv.isDarwin)
, libX11
, libXext
, libXi
, libXrandr
, enableCurl ? true
, curl
, openssl
, enableGL ? true
, freeglut
, libGLU
, xcbuild
}:
let

  # OpenJPEG version is hardcoded in package source
  openJpegVersion = with stdenv;
    lib.versions.majorMinor (lib.getVersion openjpeg);


in
stdenv.mkDerivation rec {
  version = "1.20.3";
  pname = "mupdf";

  src = fetchurl {
    url = "https://mupdf.com/downloads/archive/${pname}-${version}-source.tar.gz";
    sha256 = "sha256-a2AHD27sIOjYfStc0iz0kCAxGjzxXuEJmOPl9fmEses=";
  };

  patches = [ ./0001-Use-command-v-in-favor-of-which.patch
              ./0002-Add-Darwin-deps.patch
            ];

  postPatch = ''
    sed -i "s/__OPENJPEG__VERSION__/${openJpegVersion}/" source/fitz/load-jpx.c
  '';

  # Use shared libraries to decrease size
  buildFlags = [ "shared" ];

  makeFlags = [ "prefix=$(out)" "USE_SYSTEM_LIBS=yes" ]
    ++ lib.optionals (!enableX11) [ "HAVE_X11=no" ]
    ++ lib.optionals (!enableGL) [ "HAVE_GLUT=no" ];

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional (enableGL || enableX11) copyDesktopItems
    ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [ freetype harfbuzz openjpeg jbig2dec libjpeg gumbo ]
    ++ lib.optional stdenv.isDarwin xcbuild
    ++ lib.optionals enableX11 [ libX11 libXext libXi libXrandr ]
    ++ lib.optionals enableCurl [ curl openssl ]
    ++ lib.optionals enableGL (
    if stdenv.isDarwin then
      with darwin.apple_sdk.frameworks; [ GLUT OpenGL ]
    else
      [ freeglut libGLU ]
  )
  ;
  outputs = [ "bin" "dev" "out" "man" "doc" ];

  preConfigure = ''
    # Don't remove mujs because upstream version is incompatible
    rm -rf thirdparty/{curl,freetype,glfw,harfbuzz,jbig2dec,libjpeg,openjpeg,zlib}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = pname;
      comment = meta.description;
      icon = "mupdf";
      exec = "${pname} %f";
      terminal = false;
      mimeTypes = [
        "application/epub+zip"
        "application/oxps"
        "application/pdf"
        "application/vnd.ms-xpsdocument"
        "application/x-cbz"
        "application/x-pdf"
      ];
      categories = [ "Graphics" "Viewer" ];
      keywords = [
        "mupdf" "comic" "document" "ebook" "viewer"
        "cbz" "epub" "fb2" "pdf" "xps"
      ];
    })
  ];

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
  '' + lib.optionalString (enableX11 || enableGL) ''
    mkdir -p $bin/share/icons/hicolor/48x48/apps
    cp docs/logo/mupdf.png $bin/share/icons/hicolor/48x48/apps
  '' + (if enableGL then ''
    ln -s "$bin/bin/mupdf-gl" "$bin/bin/mupdf"
  '' else lib.optionalString (enableX11) ''
    ln -s "$bin/bin/mupdf-x11" "$bin/bin/mupdf"
  '');

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://mupdf.com";
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vrthra fpletz ];
    platforms = platforms.unix;
  };
}
