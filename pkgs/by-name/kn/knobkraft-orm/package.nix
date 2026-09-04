{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
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
  libxtst,
  libxdmcp,
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

  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "christofmuc";
    repo = "knobkraft-orm";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-5d1sYoNBLspBc8b8dwNS1H7dTSFiMBPHE7Ti1MV3Sv0=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
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
    libxdmcp
    lerc
    libxkbcommon
    libepoxy
    libxtst
    sqlite
    git
    libdeflate
    xz
    libwebp
  ];

  # Archive toolchain workaround and version injection for sources without Git metadata.
  # Upstream discussion: https://github.com/christofmuc/KnobKraft-orm/pull/486
  patches = [ ./temporary.patch ];

  postPatch = ''
    # Keep bundled adaptations and their support modules out of bin.
    substituteInPlace adaptations/CMakeLists.txt \
      --replace-fail 'DESTINATION bin' 'DESTINATION share/knobkraft-orm/adaptations'
    # Update Python imports, discovery, built-in names and adaptation export.
    substituteInPlace adaptations/GenericAdaptation.cpp \
      --replace-fail 'getChildFile("adaptations")' 'getChildFile("../share/knobkraft-orm/adaptations")'
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INTERPROCEDURAL_OPTIMIZATION" "OFF")
    (lib.cmakeFeature "KNOBKRAFT_EXTERNAL_VERSION" finalAttrs.version)
    (lib.cmakeFeature "PYTHON_VERSION_TO_EMBED" "${python312.pythonVersion}")
  ];

  makeFlags = [
    "package"
  ];

  postInstall = ''
    # Embedded Python must find its own standard-library extension modules.
    wrapProgram "$out/bin/KnobKraftOrm" \
      --set PYTHONHOME "${python312}"
  '';

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
