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
  libxdmcp,
  libxkbcommon,
  libxml2,
  libxtst,
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
stdenv.mkDerivation {
  pname = "ansel";
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "aurelienpierreeng";
    repo = "ansel";
    rev = "11fe9d529a18ff4f23c440939f53593eb74212b1";
    hash = "sha256-REOmcSQ5RpeBpkwk6Z4Rgul6OMELf4+bpAhZGSwr4w4=";
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
    libxdmcp
    libxkbcommon
    libxml2
    libxtst
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

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "target_include_directories(ansel_deps INTERFACE" "target_include_directories(ansel_deps INTERFACE ${glib.dev}/include/gio-unix-2.0/"
  '';

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
