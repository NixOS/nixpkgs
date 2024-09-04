{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
, wayland-scanner
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

  patches = [
    # CMakeLists: look for wayland.xml protocol in wayland-scanner pkgdata
    (fetchpatch {
      url = "https://github.com/hyprwm/hyprpaper/commit/6c6e54faa84d2de94d2321eda43a8a669ebf3312.patch";
      hash = "sha256-Ns7HlUPVgBDIocZRGR6kIW58Mt92kJPQRMSKTvp6Vik=";
    })
  ];

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
