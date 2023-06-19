{ lib
, fetchFromGitHub
, rustPlatform
, gitUpdater

, autoPatchelfHook
, pkg-config

, gcc-unwrapped
, fontconfig
, libGL
, vulkan-loader

, withX11 ? true
, libX11
, libXcursor
, libXi
, libXrandr
, libxcb

, withWayland ? false
, wayland
}:
let
  rlinkLibs = [
    (lib.getLib gcc-unwrapped)
    fontconfig
    libGL
    vulkan-loader
  ] ++ lib.optional withX11 [
    libX11
    libXcursor
    libXi
    libXrandr
    libxcb
  ] ++ lib.optional withWayland [
    wayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "rio";
  version = "0.0.6.1-unstable-2023-06-18";

  src = fetchFromGitHub {
    owner = "raphamorim";
    repo = "rio";
    rev = "f3fbe7a020528d2f5ed8beaa3afd900a4c2e83a2";
    hash = "sha256-emZqD/vvQHk43E8gTHVczCOni110sCRLMWp9igruYc8=";
  };

  cargoHash = "sha256-1ZQae5IHA+8HwyYGFBy1XPEYR8NAHHrU1JNOMT7T5zA=";

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  runtimeDependencies = rlinkLibs;

  buildInputs = rlinkLibs;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    (lib.optionalString withX11 "x11")
    (lib.optionalString withWayland "wayland")
  ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };
  };

  meta = {
    description = "A hardware-accelerated GPU terminal emulator powered by WebGPU";
    homepage = "https://raphamorim.io/rio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio oluceps ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/raphamorim/rio/blob/v${version}/CHANGELOG.md";
  };
}
