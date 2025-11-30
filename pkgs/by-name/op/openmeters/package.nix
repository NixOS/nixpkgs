{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  pkg-config,
  pipewire,
  wayland,
  fontconfig,
  freetype,
  libglvnd,
  libxkbcommon,
  xorg,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openmeters";
  version = "0-unstable-2025-11-25";

  src = fetchFromGitHub {
    owner = "httpsworldview";
    repo = "openmeters";
    rev = "0ead9cab9dc294854e0dc5efde0d9eaee34044f9";
    hash = "sha256-z2PAWmiKLWgpuxqcsGhc5bB0nNINfolLAitdE15H2LI=";
  };

  cargoHash = "sha256-z9Wab2Z8RxT/oOTjJrE7q3mq3m0QTLSOpZqfDfpmf2k=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pipewire
  ];

  postInstall = ''
    wrapProgram $out/bin/openmeters \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          fontconfig
          freetype
          libglvnd
          libxkbcommon
          wayland
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
        ]
      }
  '';

  meta = {
    description = "Fast and simple audio metering/visualization program for Linux.";
    homepage = "https://github.com/httpsworldview/openmeters";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bitbloxhub ];
    platforms = lib.platforms.linux;
    mainProgram = "openmeters";
  };
})
