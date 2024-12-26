{
  lib,
  gcc14Stdenv,
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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpaper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IRZ5NrKFwBVueYrZYUQfpTwp2rZHgAkPwgvdnfVBF8E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
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

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail GIT_COMMIT_HASH '"${finalAttrs.src.rev}"'
  '';

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "Blazing fast wayland wallpaper utility";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      fufexan
      khaneliman
      wozeparrot
    ];
    inherit (wayland.meta) platforms;
    broken = gcc14Stdenv.hostPlatform.isDarwin;
    mainProgram = "hyprpaper";
  };
})
