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
  version = "0.8.1-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpaper";
    rev = "2953d963bec2ea63b4303e269b472524db46a121";
    hash = "sha256-vxAZg+NzAKuWZv2yDrTcXrU+klpAcGFo1FvjYb/CqZ8=";
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
