{
  autoPatchelfHook,
  darwin,
  fetchFromGitHub,
  lib,
  libxkbcommon,
  fontconfig,
  pkg-config,
  rustPlatform,
  stdenv,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "simplemoji";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "SergioRibera";
    repo = "simplemoji";
    rev = "v${version}";
    hash = "sha256-MU31gRikMqXelWjwjMPZtfbDpybYlPTFr1u9w2843Kc=";
  };

  cargoHash = "sha256-NvNNc+V7wloPxM532uNrXoou4vnKLhFK29L2/17eB98=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs =
    lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.OpenGL
    ]
    ++ lib.optionals stdenv.isLinux [
      stdenv.cc.cc.libgcc
      fontconfig.dev
      libxkbcommon.dev
      wayland
      xorg.libxcb
      xorg.libX11
    ];

  runtimeDependencies = lib.optionals stdenv.isLinux [
    wayland
    libxkbcommon
    xorg.libX11
  ];

  meta = {
    description = "Fast Application for look your amazing emojis write in Rust";
    homepage = "https://github.com/SergioRibera/simplemoji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sergioribera ];
    mainProgram = "simplemoji";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
