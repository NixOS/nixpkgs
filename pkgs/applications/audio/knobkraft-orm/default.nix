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

stdenv.mkDerivation rec {
  pname = "KnobKraft-orm";

  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "christofmuc";
    repo = "knobkraft-orm";
    rev = version;
    leaveDotGit = true;
    deepClone = true;
    fetchSubmodules = true;
    hash = "sha256-teoBN1EOFCQVk93oEvj2AAjMeQP7NQjDJKZiKy1kdi0";
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
    "-D PYTHON_VERSION_TO_EMBED=3.12"
    "-D CMAKE_INTERPROCEDURAL_OPTIMIZATION=off"
  ];

  makeFlags = [
    "package"
  ];

  meta = with lib; {
    homepage = "https://github.com/christofmuc/KnobKraft-orm";
    description = "Modern FOSS MIDI Sysex Librarian";
    mainProgram = "KnobKraftOrm";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      backtail
    ];
    platforms = platforms.linux;
  };
}
