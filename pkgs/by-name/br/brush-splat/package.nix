{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  vulkan-loader,
  zstd,
  stdenv,
  wayland,
  nix-update-script,
  versionCheckHook,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brush-splat";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ArthurBrussee";
    repo = "brush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xVYZrQUgHxaefAMmSXG/rrVlCr0H5lRmyyXtRmOtbTU=";
  };

  cargoHash = "sha256-KBgE0fiaUEsGuAYGhBjqMX7ftj5JnGggH86brxq6280=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    vulkan-loader
    wayland
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath "${
      lib.makeLibraryPath [
        vulkan-loader
        wayland
        libxkbcommon
      ]
    }" $out/bin/brush_app
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
