{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, ncurses
, pkg-config
, fontconfig
, freetype
, libGL
, xorg
, libxkbcommon
, wayland
, vulkan-loader

  # Darwin Frameworks
  # , AppKit
  # , CoreGraphics
  # , CoreServices
  # , CoreText
  # , Foundation
  # , libiconv
  # , OpenGL
}:
let
  rpathLibs = [
    fontconfig
    freetype
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libxcb
  ] ++ lib.optionals stdenv.isLinux [
    libxkbcommon
    wayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "rio";
  version = "0.0.61";

  src = fetchFromGitHub {
    owner = "raphamorim";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PRYAJ4mDEE1ux3jJb5XaptJoBcLrzVRh3CZUwDrVwJs=";
  };

  cargoPatches = [
    ./update-Cargo.lock.patch
  ];

  cargoHash = "sha256-rohXT8IAHexOZ0xEJ83wB/OqL+p7Ipr8YPgmHtaDIiU=";

  nativeBuildInputs = [
    makeWrapper
    ncurses
    pkg-config
  ];

  buildInputs = rpathLibs;

  preFixup = lib.optionalString stdenv.isLinux ''
    patchelf \
      --add-needed "${libGL}/lib/libEGL.so.1" \
      --add-needed "${vulkan-loader}/lib/libvulkan.so.1" \
      $out/bin/rio
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = ''
      A hardware-accelerated GPU terminal emulator
      powered by WebGPU, focusing to run in desktops and browsers
    '';
    homepage = "https://github.com/raphamorim/rio";
    license = licenses.asl20;
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
    changelog = "https://github.com/raphamorim/rio/blob/v${version}/CHANGELOG.md";
  };
}
