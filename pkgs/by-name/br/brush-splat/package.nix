{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  libxkbcommon,
  sqlite,
  vulkan-loader,
  zstd,
  stdenv,
  wayland,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brush-splat";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ArthurBrussee";
    repo = "brush";
    tag = finalAttrs.version;
    hash = "sha256-IvsHYCM/M2hHozzKwovgXpcW1b7MSEGneU62y1k8U9U=";
  };

  cargoHash = "sha256-7cJj5L8ggkBP9SDaYMtY9xIAHVAhi8cTD/0pncUaHbI=";

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client & libxkbcommon, which is dlopen()ed based on the
  # winit backend.
  NIX_LDFLAGS = [
    "--no-as-needed"
    "-lvulkan"
    "-lwayland-client"
    "-lxkbcommon"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    libxkbcommon
    sqlite
    vulkan-loader
    zstd
  ]
  ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "3D Reconstruction for all";
    homepage = "https://github.com/ArthurBrussee/brush";
    changelog = "https://github.com/ArthurBrussee/brush/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "brush_app";
  };
})
