{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cairo,
  expat,
  file,
  fribidi,
  hyprlang,
  libdatrie,
  libGL,
  libjpeg,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-l13c8ALA7ZKDgluYA1C1OfkDGYD6e1/GR6LJnxCLRhA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    expat
    file
    fribidi
    hyprlang
    libdatrie
    libGL
    libjpeg
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
  ];

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace GIT_COMMIT_HASH '"${finalAttrs.src.rev}"'
  '';

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "A blazing fast wayland wallpaper utility";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      wozeparrot
      fufexan
    ];
    inherit (wayland.meta) platforms;
    broken = stdenv.isDarwin;
    mainProgram = "hyprpaper";
  };
})
