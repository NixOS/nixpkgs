{
  bash,
  cmake,
  colord,
  colord-gtk,
  curl,
  dav1d,
  desktop-file-utils,
  exiftool,
  exiv2,
  fetchFromGitHub,
  glib,
  gmic,
  graphicsmagick,
  gtk3,
  icu,
  intltool,
  isocodes,
  jasper,
  json-glib,
  lcms,
  lensfun,
  lerc,
  lib,
  libaom,
  libavif,
  libdatrie,
  libde265,
  libepoxy,
  libffi,
  libgcrypt,
  libgpg-error,
  libheif,
  libjpeg,
  libpsl,
  librsvg,
  libsecret,
  libselinux,
  libsepol,
  libsoup_3,
  libsysprof-capture,
  libthai,
  libwebp,
  libXdmcp,
  libxkbcommon,
  libxml2,
  libXtst,
  llvmPackages,
  openexr,
  openjpeg,
  osm-gps-map,
  pcre2,
  perlPackages,
  pkg-config,
  pugixml,
  python3Packages,
  rav1e,
  saxon,
  sqlite,
  stdenv,
  unstableGitUpdater,
  util-linux,
  wrapGAppsHook3,
  x265,
}:

let
  # requires libavif 0.x, see https://github.com/aurelienpierreeng/ansel/blob/e2c4a0a60cd80f741dd3d3c6ab72be9ac11234fb/src/CMakeLists.txt#L356
  libavif_0_11 = libavif.overrideAttrs rec {
    version = "0.11.1";

    src = fetchFromGitHub {
      owner = "AOMediaCodec";
      repo = "libavif";
      tag = "v${version}";
      hash = "sha256-mUi0DU99XV3FzUZ8/9uJZU+W3fc6Bk6+y6Z78IRZ9Qs=";
    };

    patches = [ ];
    doCheck = false;
  };
in
stdenv.mkDerivation {
  pname = "ansel";
  version = "0-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "aurelienpierreeng";
    repo = "ansel";
    rev = "b51cfa38c41abe9933b40e1583807b105c5933c1";
    hash = "sha256-EEML6agNDQbCZ1+b4dTHr3JA9Jh3iTW0U4krVylGVTg=";
    fetchSubmodules = true;
  };

  patches = [
    # don't use absolute paths to binary or icon - see https://github.com/NixOS/nixpkgs/issues/308324
    ./fix-desktop-file.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    desktop-file-utils
    exiftool
    intltool
    llvmPackages.llvm
    pkg-config
    perlPackages.perl
    python3Packages.jsonschema
    wrapGAppsHook3
    saxon
  ];

  buildInputs = [
    bash # for patchShebangs to patch scripts in share/ansel/tools/
    colord
    colord-gtk
    curl
    dav1d
    exiv2
    json-glib
    glib
    gmic
    graphicsmagick
    gtk3
    icu
    isocodes
    jasper
    lcms
    lensfun
    lerc
    libaom
    libavif
    libdatrie
    libde265
    libepoxy
    libffi
    libgcrypt
    libgpg-error
    libheif
    libjpeg
    libpsl
    librsvg
    libsecret
    libselinux
    libsepol
    libsoup_3
    libsysprof-capture
    libthai
    libwebp
    libXdmcp
    libxkbcommon
    libxml2
    libXtst
    openexr
    openjpeg
    osm-gps-map
    pcre2
    perlPackages.Po4a
    pugixml
    rav1e
    sqlite
    util-linux
    x265
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH ":" "$out/lib/ansel"
    )
  '';
  cmakeFlags = [
    "-DBINARY_PACKAGE_BUILD=1"
  ];

  passthru.updateScript = unstableGitUpdater {
    # Tags inherited from Darktable, + a "nightly" 0.0.0 tag that new artefacts get attached to
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Darktable fork minus the bloat plus some design vision";
    homepage = "https://ansel.photos/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mBornand ];
    mainProgram = "ansel";
    platforms = lib.platforms.linux;
  };
}
