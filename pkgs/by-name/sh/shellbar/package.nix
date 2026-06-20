{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, zig
, gtk4
, libadwaita
, cairo
, pango
, gdk-pixbuf
, graphene
, harfbuzz
, vulkan-headers
, vulkan-loader
, glib
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "shellbar";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "rendergraf";
    repo = "shellbar";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    zig
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    cairo
    pango
    gdk-pixbuf
    graphene
    harfbuzz
    vulkan-headers
    vulkan-loader
    glib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = with lib; {
    description = "A Ghostty-like terminal emulator with a configurable command toolbar";
    homepage = "https://github.com/rendergraf/shellbar";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "shellbar";
  };
}
