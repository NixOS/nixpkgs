{ lib
, stdenv
, fetchFromGitHub
, cmake
, cairo
, expat
, file
, fribidi
, hyprlang
, libdatrie
, libGL
, libjpeg
, libselinux
, libsepol
, libthai
, libwebp
, libXdmcp
, pango
, pcre
, pcre2
, pkg-config
, util-linux
, wayland
, wayland-protocols
, hyprwayland-scanner
, hyprutils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpaper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HIK7XJWQCM0BAnwW5uC7P0e7DAkVTy5jlxQ0NwoSy4M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    hyprwayland-scanner
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
    hyprutils
  ];

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace GIT_COMMIT_HASH '"${finalAttrs.src.rev}"'
  '';

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "Blazing fast wayland wallpaper utility";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wozeparrot fufexan ];
    inherit (wayland.meta) platforms;
    broken = stdenv.isDarwin;
    mainProgram = "hyprpaper";
  };
})
