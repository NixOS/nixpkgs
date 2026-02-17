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
  libxrandr,
  libxi,
  libxcursor,
  libx11,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openmeters";
  version = "0-unstable-2025-12-15";

  src = fetchFromGitHub {
    owner = "httpsworldview";
    repo = "openmeters";
    rev = "701b22b40796e33b118719724a54be231144a5ac";
    hash = "sha256-svsC0lxAnkVuyk6LZPyFSjeOL8H0yY3dRA37+K1e/xY=";
  };

  cargoHash = "sha256-jm/8FdJiVVh/PAyJiLA/KK4IaXi4gUBMGIKz/FL3KZ8=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pipewire
  ];

  postFixup = ''
    patchelf --add-rpath '${
      lib.makeLibraryPath [
        fontconfig
        freetype
        libglvnd
        libxkbcommon
        wayland
        libx11
        libxcursor
        libxi
        libxrandr
      ]
    }' $out/bin/openmeters
  '';

  meta = {
    description = "Fast and simple audio metering/visualization program for Linux";
    homepage = "https://github.com/httpsworldview/openmeters";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bitbloxhub ];
    platforms = lib.platforms.linux;
    mainProgram = "openmeters";
  };
})
