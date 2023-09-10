{ stdenv
, lib
, fetchurl
, fetchpatch
, fetchFromGitHub
, copyDesktopItems
, makeDesktopItem
, desktopToDarwinBundle
, buildPackages
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
, gitUpdater

# for passthru.tests
, cups-filters
, python3
, zathura
}:
let

  # OpenJPEG version is hardcoded in package source
  openJpegVersion = with stdenv;
    lib.versions.majorMinor (lib.getVersion openjpeg);

  freeglut-mupdf = freeglut.overrideAttrs (old: rec {
    pname = "freeglut-mupdf";
    version = "3.0.0-r${src.rev}";
    src = fetchFromGitHub {
      owner = "ArtifexSoftware";
      repo = "thirdparty-freeglut";
      rev = "13ae6aa2c2f9a7b4266fc2e6116c876237f40477";
      hash = "sha256-0fuE0lm9rlAaok2Qe0V1uUrgP4AjMWgp3eTbw8G6PMM=";
    };
  });

in
stdenv.mkDerivation rec {
  version = "1.23.0";
  pname = "mupdf";

  src = fetchurl {
    url = "https://mupdf.com/downloads/archive/${pname}-${version}-source.tar.gz";
    sha256 = "sha256-3kFAaS5pMULDEeAwrBVuOO4XXXq2wb4QxcmuljhGFk4=";
  };

  patches = [ ./0001-Use-command-v-in-favor-of-which.patch
              ./0002-Add-Darwin-deps.patch
            ];

  postPatch = ''
    sed -i "s/__OPENJPEG__VERSION__/${openJpegVersion}/" source/fitz/load-jpx.c
    substituteInPlace Makerules --replace "(shell pkg-config" "(shell $PKG_CONFIG"
  '';

  # Use shared libraries to decrease size
  buildFlags = [ "shared" ];

  makeFlags = [
    "prefix=$(out)"
    "USE_SYSTEM_LIBS=yes"
    "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  ] ++ lib.optionals (!enableX11) [ "HAVE_X11=no" ]
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
      [ freeglut-mupdf libGLU ]
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

  passthru = {
    tests = {
      inherit cups-filters zathura;
      inherit (python3.pkgs) pikepdf pymupdf;
    };

    updateScript = gitUpdater {
      url = "https://git.ghostscript.com/mupdf.git";
      ignoredVersions = ".rc.*";
    };
  };

  meta = with lib; {
    homepage = "https://mupdf.com";
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    changelog = "https://git.ghostscript.com/?p=mupdf.git;a=blob_plain;f=CHANGES;hb=${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vrthra fpletz ];
    platforms = platforms.unix;
    mainProgram = "mupdf";
  };
}
