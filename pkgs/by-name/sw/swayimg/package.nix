{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-scanner
, wayland
, wayland-protocols
, json_c
, libxkbcommon
, fontconfig
, giflib
, libheif
, libjpeg
, libwebp
, libtiff
, librsvg
, libpng
, libjxl
, libexif
, openexr_3
, bash-completion
}:
stdenv.mkDerivation rec {
  pname = "swayimg";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aKDt4lPh4w0AOucN7VrA7mo8SHI9eJqdrpJF+hG93gI=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];

  buildInputs = [
    bash-completion
    wayland
    wayland-protocols
    json_c
    libxkbcommon
    fontconfig
    giflib
    libheif
    libjpeg
    libwebp
    libtiff
    librsvg
    libpng
    libjxl
    libexif
    openexr_3
  ];

  meta = with lib; {
    homepage = "https://github.com/artemsen/swayimg";
    description = "Image viewer for Sway/Wayland";
    changelog = "https://github.com/artemsen/swayimg/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
    mainProgram = "swayimg";
  };
}
