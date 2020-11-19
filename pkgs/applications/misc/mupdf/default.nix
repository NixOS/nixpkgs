{ stdenv, lib, fetchurl, fetchpatch, pkgconfig, freetype, harfbuzz, openjpeg
, jbig2dec, libjpeg , darwin
, gumbo
, enableX11 ? true, libX11, libXext, libXi, libXrandr
, enableCurl ? true, curl, openssl
, enableGL ? true, freeglut, libGLU
}:

let

  # OpenJPEG version is hardcoded in package source
  openJpegVersion = with stdenv;
    lib.versions.majorMinor (lib.getVersion openjpeg);


in stdenv.mkDerivation rec {
  version = "1.18.0";
  pname = "mupdf";

  src = fetchurl {
    url = "https://mupdf.com/downloads/archive/${pname}-${version}-source.tar.gz";
    sha256 = "0rljl44y8p8hgaqializlyrgpij1wbnrzyp0ll5kcg7w05nylq48";
  };

  patches =
    stdenv.lib.optional stdenv.isDarwin ./darwin.patch ++ [
    (fetchpatch {
        name = "pdfocr.patch";
        url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=a507b139adf37d2c742e039815601cdc2aa00a84";
        sha256 = "1fx6pdgwrbk3bqsx53764d61llfj9s5q8lxqkna7mjnp7mg4krj3";
      })
    (fetchpatch {
        name = "pdf-layer.patch";
        url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=b82e9b6d6b46877e5c3763cc3bc641c66fa7eb54";
        sha256 = "0ma8jq8d9a0mf26qjklgi4gdaflpjik1br1nhafzvjz7ccl56ksm";
      })
    (fetchpatch {
        name = "pixmap.patch";
        url = "http://git.ghostscript.com/?p=mupdf.git;a=patch;h=32e4e8b4bcbacbf92af7c88337efae21986d9603";
        sha256 = "1zqkxgwrhcwsdya98pcmpq2815jjmv3fwsp0sba9f5nq5xi6whbj";
      })
    ];

  postPatch = ''
    sed -i "s/__OPENJPEG__VERSION__/${openJpegVersion}/" source/fitz/load-jpx.c
  '';

  # Use shared libraries to decrease size
  buildFlags = [ "shared" ];

  makeFlags = [ "prefix=$(out) USE_SYSTEM_LIBS=yes" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ freetype harfbuzz openjpeg jbig2dec libjpeg freeglut libGLU gumbo ]
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
    ln -s "$bin/bin/mupdf-x11" "$bin/bin/mupdf"
    mkdir -p $bin/share/applications
    cat > $bin/share/applications/mupdf.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=mupdf
    Comment=PDF viewer
    Exec=$bin/bin/mupdf-x11 %f
    Terminal=false
    MimeType=application/pdf;application/x-pdf;application/x-cbz;application/oxps;application/vnd.ms-xpsdocument;application/epub+zip
    EOF
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://mupdf.com";
    repositories.git = "git://git.ghostscript.com/mupdf.git";
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vrthra fpletz ];
    platforms = platforms.unix;
  };
}
