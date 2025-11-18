{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,

  gtk3,
  glew,
  webkitgtk_4_1,
  cppcheck,
  icu,
  python312,
  glib,
  curlFull,
  boost,
  libbtbb,
  libsysprof-capture,
  pcre2,
  alsa-lib,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  xorg,
  lerc,
  libxkbcommon,
  libepoxy,
  sqlite,
  git,
  libdeflate,
  xz,
  libwebp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "KnobKraft-orm";

  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "christofmuc";
    repo = "knobkraft-orm";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-dOgPq4r2IvKDPhhV/LWRfGeeFckN5ZUeee/T6QNfCtw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtk3
    glew
    webkitgtk_4_1
    cppcheck
    icu
    python312
    glib
    curlFull
    boost
    libbtbb
    libsysprof-capture
    pcre2
    alsa-lib
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    xorg.libXdmcp
    lerc
    libxkbcommon
    libepoxy
    xorg.libXtst
    sqlite
    git
    libdeflate
    xz
    libwebp
  ];

  # Issue has been raised and should be resolved with next release.
  # CMakeLists.txt needs three more lines to properly build.
  patches = [ ./temporary.patch ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INTERPROCEDURAL_OP" "off")
    (lib.cmakeFeature "PYTHON_VERSION_TO_EMBED" "${python312.pythonVersion}")
  ];

  makeFlags = [
    "package"
  ];

  meta = {
    homepage = "https://github.com/christofmuc/KnobKraft-orm";
    description = "Modern FOSS MIDI Sysex Librarian";
    mainProgram = "KnobKraftOrm";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      backtail
    ];
    platforms = lib.platforms.linux;
  };
})
