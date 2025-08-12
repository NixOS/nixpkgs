{
  lib,
  stdenv,
  callPackage,
  fetchFromGitLab,
  fetchgit,
  cmake,
  jdk17,
  pkg-config,
  cairo,
  expat,
  fontconfig,
  freetype,
  glib,
  libjpeg,
  libpng,
  libxml2,
  xorg,
}:
let
  poppler = callPackage ./poppler.nix { };
  poppler-data = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "poppler";
    repo = "poppler-data";
    tag = "POPPLER_DATA_0_4_9";
    hash = "sha256-sNvIgxXXLuTe7JWs67Z+fv4r4smLPKpDu83fvRYoasQ=";
  };
  fontforge = callPackage ./fontforge.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pdf2htmlex";
  version = "0.18.8.rc1";

  src = fetchgit {
    url = "https://github.com/pdf2htmlEX/pdf2htmlex.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ylLDLheRUy1hAxVneF1HQwDnGTWko0SE3G1M9SFCr9w=";
  };

  patches = [
    ./0001-fix-apple-sdk-iconv.patch
    ./0002-include-glib.patch
  ];

  # The pdf2htmlEX needs lots of private headers from poppler and fontforge,
  # it also needs the static libraries.
  postUnpack = ''
    pushd pdf2htmlex

    install -Dvm644 -t ./poppler/build/poppler/glib ${poppler}/include/poppler/glib/*.h
    install -Dvm644 -t ./poppler/poppler/ ${poppler}/include/poppler/*.h
    install -Dvm644 -t ./poppler/poppler/ ${poppler.src}/poppler/*.h
    install -Dvm644 -t ./poppler/fofi/ ${poppler.src}/fofi/*.h
    install -Dvm644 -t ./poppler/goo/ ${poppler.src}/goo/*.h
    install -Dvm644 -t ./poppler/splash/ ${poppler.src}/splash/*.h
    install -Dvm644 -t ./poppler/build/ ${poppler}/lib/libpoppler.a
    install -Dvm644 -t ./poppler/build/glib/ ${poppler}/lib/libpoppler-glib.a

    cp -rv ${poppler-data} poppler-data

    install -Dvm644 -t ./fontforge/inc/ ${fontforge}/include/*.h
    install -Dvm644 -t ./fontforge/inc/ ${fontforge.src}/inc/*.h
    install -Dvm644 -t ./fontforge/fontforge/ ${fontforge.src}/fontforge/*.h
    install -Dvm644 -t ./fontforge/build/lib/ ${fontforge}/lib/libfontforge.a

    popd
  '';

  preConfigure = ''
    cd pdf2htmlEX
  '';

  buildInputs = [
    cairo
    expat
    fontconfig
    freetype
    glib
    libjpeg
    libpng
    libxml2
    xorg.libXdmcp
  ];

  nativeBuildInputs = [
    cmake
    jdk17
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_RPATH" (lib.makeLibraryPath [ freetype ]))
  ];

  meta = {
    description = "Convert PDF to HTML";
    homepage = "https://github.com/pdf2htmlEX/pdf2htmlEX";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; (linux ++ darwin);
    maintainers = with lib.maintainers; [ Cryolitia ];
    mainProgram = "pdf2htmlEX";
  };
})
