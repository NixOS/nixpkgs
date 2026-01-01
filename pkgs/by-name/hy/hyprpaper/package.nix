{
  lib,
<<<<<<< HEAD
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
=======
  stdenv,
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libjpeg,
  libjxl,
  libselinux,
  libsepol,
  libthai,
  libwebp,
<<<<<<< HEAD
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
=======
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

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "0.7.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpaper";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-5h8HbO71r+QD94WZ/Xm3K0X706+x5c+/96daRpL/0zo=";
=======
    hash = "sha256-l/OxM4q/nLVv47OuS4bG2J7k0m+G7/3AMtvrV64XLb0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail GIT_COMMIT_HASH '"${finalAttrs.src.rev}"'
  '';
<<<<<<< HEAD

  nativeBuildInputs = [
    cmake
    hyprwayland-scanner
    hyprwire
    pkg-config
=======
  postPatch = ''
    substituteInPlace src/helpers/MiscFunctions.cpp \
      --replace-fail '/bin/bash' '${bash}/bin/bash'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    wayland-scanner
  ];

  buildInputs = [
<<<<<<< HEAD
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
=======
    cairo
    bash
    expat
    file
    fribidi
    hyprlang
    libdatrie
    libGL
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    libjpeg
    libjxl
    libselinux
    libsepol
    libthai
    libwebp
<<<<<<< HEAD
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
=======
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
    broken = stdenv.hostPlatform.isDarwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "hyprpaper";
  };
})
