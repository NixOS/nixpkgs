{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  hyprwayland-scanner,
  hyprwire,
  pkg-config,
  wayland-scanner,
  aquamarine,
  cairo,
  expat,
  file,
  fribidi,
  hyprgraphics,
  hyprlang,
  hyprutils,
  hyprtoolkit,
  libGL,
  libdatrie,
  libdrm,
  libjpeg,
  libjxl,
  libselinux,
  libsepol,
  libthai,
  libwebp,
  libxdmcp,
  pango,
  pcre,
  pcre2,
  wayland,
  wayland-protocols,
  util-linux,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpaper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5h8HbO71r+QD94WZ/Xm3K0X706+x5c+/96daRpL/0zo=";
  };

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail GIT_COMMIT_HASH '"${finalAttrs.src.rev}"'
  '';

  nativeBuildInputs = [
    cmake
    hyprwayland-scanner
    hyprwire
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    aquamarine
    cairo
    expat
    file
    fribidi
    hyprgraphics
    hyprlang
    hyprutils
    hyprtoolkit
    libGL
    libdatrie
    libdrm
    libjpeg
    libjxl
    libselinux
    libsepol
    libthai
    libwebp
    libxdmcp
    pango
    pcre
    pcre2
    wayland
    wayland-protocols
    util-linux
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Blazing fast wayland wallpaper utility";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    inherit (wayland.meta) platforms;
    broken = gcc15Stdenv.hostPlatform.isDarwin;
    mainProgram = "hyprpaper";
  };
})
