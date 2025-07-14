{
  lib,
  gcc14Stdenv,
  fetchFromGitHub,
  cmake,
  cairo,
  bash,
  expat,
  file,
  fribidi,
  hyprlang,
  libdatrie,
  libGL,
  libjpeg,
  libjxl,
  libselinux,
  libsepol,
  libthai,
  libwebp,
  libXdmcp,
  pango,
  pcre,
  pcre2,
  pkg-config,
  util-linux,
  wayland,
  wayland-protocols,
  wayland-scanner,
  hyprwayland-scanner,
  hyprutils,
  hyprgraphics,
}:

gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpaper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q5gDH48MqkiglGvRtD0Uj653kYzu46j27JIB0h1ecEg=";
  };

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail GIT_COMMIT_HASH '"${finalAttrs.src.rev}"'
  '';
  postPatch = ''
    substituteInPlace src/helpers/MiscFunctions.cpp \
      --replace-fail '/bin/bash' '${bash}/bin/bash'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
    wayland-scanner
  ];

  buildInputs = [
    cairo
    bash
    expat
    file
    fribidi
    hyprlang
    libdatrie
    libGL
    libjpeg
    libjxl
    libselinux
    libsepol
    libthai
    libwebp
    libXdmcp
    pango
    pcre
    pcre2
    util-linux
    wayland
    wayland-protocols
    hyprutils
    hyprgraphics
  ];

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "Blazing fast wayland wallpaper utility";
    license = licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    inherit (wayland.meta) platforms;
    broken = gcc14Stdenv.hostPlatform.isDarwin;
    mainProgram = "hyprpaper";
  };
})
