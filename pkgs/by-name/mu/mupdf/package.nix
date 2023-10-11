{ stdenv
, lib
, fetchurl
, fetchpatch
, fetchFromGitHub
, buildPackages
, copyDesktopItems
, copyPkgconfigItems
, cups-filters
, curl
, darwin
, desktopToDarwinBundle
, freeglut
, freetype
, gitUpdater
, gumbo
, harfbuzz
, jbig2dec
, libGLU
, libX11
, libXext
, libXi
, libXrandr
, libjpeg
, makeDesktopItem
, makePkgconfigItem
, openjpeg
, openssl
, pkg-config
, python3
, xcbuild
, zathura
, enableCurl ? true
, enableGL ? true
, enableX11 ? (!stdenv.isDarwin)
}:

let
  # OpenJPEG version is hardcoded in package source
  openJpegVersion = lib.versions.majorMinor (lib.getVersion openjpeg);

  freeglut-mupdf = freeglut.overrideAttrs (old:
    let
      pname = "freeglut-mupdf";
      version = "3.0.0-r${rev}";
      rev = "13ae6aa2c2f9a7b4266fc2e6116c876237f40477";
    in {
      inherit pname version;
      src = fetchFromGitHub {
        owner = "ArtifexSoftware";
        repo = "thirdparty-freeglut";
        inherit rev;
        hash = "sha256-0fuE0lm9rlAaok2Qe0V1uUrgP4AjMWgp3eTbw8G6PMM=";
      };
    });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mupdf";
  version = "1.23.4";

  src = fetchurl {
    url = "https://mupdf.com/downloads/archive/mupdf-${finalAttrs.version}-source.tar.gz";
    hash = "sha256-3rA0ej+c4JZ2EdR5qKB7V+LHMLCq8J3OKO5Bq7msSDg=";
  };

  patches = [
    ./0001-Use-command-v-in-favor-of-which.patch
    ./0002-Add-Darwin-deps.patch
  ];

  postPatch = ''
    sed -i "s/__OPENJPEG__VERSION__/${openJpegVersion}/" source/fitz/load-jpx.c
    substituteInPlace Makerules --replace "(shell pkg-config" "(shell $PKG_CONFIG"
  '';

  nativeBuildInputs = [
    copyPkgconfigItems
    pkg-config
  ]
  ++ lib.optional (enableGL || enableX11) copyDesktopItems
  ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [
    freetype harfbuzz openjpeg jbig2dec libjpeg gumbo
  ]
  ++ lib.optionals stdenv.isDarwin [ xcbuild ]
  ++ lib.optionals enableX11 [ libX11 libXext libXi libXrandr ]
  ++ lib.optionals enableCurl [ curl openssl ]
  ++ lib.optionals enableGL (
    if stdenv.isDarwin then
      with darwin.apple_sdk.frameworks; [ GLUT OpenGL ]
    else
      [ freeglut-mupdf libGLU ]
  );

  # Use shared libraries to decrease size
  buildFlags = [ "shared" ];

  makeFlags = [
    "prefix=$(out)"
    "USE_SYSTEM_LIBS=yes"
    "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  ]
  ++ lib.optionals (!enableX11) [ "HAVE_X11=no" ]
  ++ lib.optionals (!enableGL) [ "HAVE_GLUT=no" ];

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  preConfigure = ''
    # Don't remove mujs because upstream version is incompatible
    rm -rf thirdparty/{curl,freetype,glfw,harfbuzz,jbig2dec,libjpeg,openjpeg,zlib}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "mupdf";
      desktopName = "mupdf";
      comment = finalAttrs.meta.description;
      icon = "mupdf";
      exec = "mupdf %f";
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

  pkgconfigItems = [
    (makePkgconfigItem {
      name = "mupdf";
      inherit (finalAttrs) version;
      description = "Library for rendering PDF documents";
      cflags = [ "-I${placeholder "dev"}/include" ];
      libs = [
        "-L${placeholder "out"}/lib"
        "-lmupdf"
        "-lmupdf-third"
      ];
      variables = {
        prefix = "${placeholder "out"}";
        includedir = "${placeholder "out"}/include";
        libdir = "${placeholder "out"}/lib";
      };
    })
  ];

  postInstall = ''
    moveToOutput "bin" "$bin"
  ''
  + lib.optionalString (enableX11 || enableGL) ''
    mkdir -p $bin/share/icons/hicolor/48x48/apps
    cp docs/logo/mupdf.png $bin/share/icons/hicolor/48x48/apps
  ''
  + (if enableGL then ''
    ln -s "$bin/bin/mupdf-gl" "$bin/bin/mupdf"
  ''
     else lib.optionalString (enableX11) ''
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

  meta = {
    homepage = "https://mupdf.com";
    description = "Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C";
    changelog = "https://git.ghostscript.com/?p=mupdf.git;a=blob_plain;f=CHANGES;hb=${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "mupdf";
    maintainers = with lib.maintainers; [ vrthra fpletz ];
    platforms = lib.platforms.unix;
  };
})
