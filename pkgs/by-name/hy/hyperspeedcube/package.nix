{
  cmake,
  alsa-lib,
  atk,
  cairo,
  directx-shader-compiler,
  expat,
  fetchFromGitHub,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  lib,
  libGL,
  libX11,
  libxcb,
  libXcursor,
  libXi,
  libxkbcommon,
  libXrandr,
  makeWrapper,
  mold,
  pango,
  pkg-config,
  python3,
  rustPlatform,
  shaderc,
  vulkan-extension-layer,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
  vulkan-tools-lunarg,
  vulkan-validation-layers,
  wayland,
  wrapGAppsHook3,
  yq,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperspeedcube";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "HactarCE";
    repo = "Hyperspeedcube";
    tag = "v${version}";
    hash = "sha256-ctBvc2xANM/gGzDDv8ygSO4nTOiG6iKyuSKnz385PIw=";
  };

  cargoHash = "sha256-ebjkEWYeeXHuKQzqbMe8+zVol2vPyLiu7ke5Ng7gbs8=";

  nativeBuildInputs = [
    cmake
    pkg-config
    (lib.getDev libxcb)
    python3
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    directx-shader-compiler
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    mold
    pango
    shaderc
    zlib

    # for execution errors (see https://github.com/emilk/egui/discussions/1587)
    libxkbcommon
    libGL

    # WINIT_UNIX_BACKEND=wayland
    wayland

    # WINIT_UNIX_BACKEND=x11
    libXcursor
    libXrandr
    libXi
    libX11

    vulkan-headers
    vulkan-loader
    vulkan-tools
    vulkan-tools-lunarg
    vulkan-extension-layer
    vulkan-validation-layers

    yq
  ];

  postInstall = ''
    patchelf \
      --add-needed ${vulkan-loader}/lib/libvulkan.so.1 \
      --add-needed ${libGL}/lib/libEGL.so.1 \
      $out/bin/hyperspeedcube
    wrapProgram $out/bin/hyperspeedcube --set WAYLAND_DISPLAY "" --set XDG_SESSION_TYPE ""
    touch $out/bin/nonportable
  '';

  meta = {
    description = "3D and 4D Rubik's cube simulator";
    longDescription = ''
      Hyperspeedcube is a modern, beginner-friendly 3D and 4D Rubik's cube
      simulator with customizable mouse and keyboard controls and advanced
      features for speedsolving. It's been used to break numerous speedsolving
      records and runs on all major operating systems plus the web.
    '';
    homepage = "https://ajfarkas.dev/hyperspeedcube/";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = [ lib.maintainers.omnipotententity ];
    platforms = [ "x86_64-linux" ];
  };
}
