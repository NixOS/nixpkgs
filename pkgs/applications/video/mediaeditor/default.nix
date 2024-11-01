{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libass
, ffmpeg
, fontconfig
, SDL2
, expat
, imgui
, glew
, glfw
, harfbuzz
, glib
, pcre2
, fribidi
, glslang
, spirv-tools
, vulkan-tools
, vulkan-loader
, xorg
, gmp
}:

stdenv.mkDerivation rec {
  pname = "media-editor";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "opencodewin";
    repo = "MediaEditor";
    rev = "v${version}";
    hash = "sha256-HS1SVI0o0mFILnz7hVSecS0qmE0yD1T2p3BKcAj2fh8=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libass
    ffmpeg
    fontconfig
    SDL2
    expat
    imgui

    glew
    glfw
    harfbuzz
    glib
    fribidi
    pcre2
    glslang
    spirv-tools
    vulkan-tools
    vulkan-loader
    xorg.libXau
    xorg.libXdmcp
    xorg.libXext
    xorg.libXcursor
    xorg.libXi
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXScrnSaver
    gmp
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "A non-linear editing software that helps you to make nice video";
    homepage = "https://github.com/opencodewin/MediaEditor";
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
