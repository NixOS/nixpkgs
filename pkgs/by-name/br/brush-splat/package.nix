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
  libx11,
  libxcursor,
  libxi,
  libxrandr,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brush-splat";
  # Temporary until new stable version releases
  version = "0.3.0-unstable-2026-07-01";

  src = fetchFromGitHub {
    owner = "ArthurBrussee";
    repo = "brush";
    rev = "3b80985709e2ec04fd6c8622a40e36473647a8e0";
    hash = "sha256-yyfnBz6NqoNBF4X087c4VoRiIUp7qgskemlHu0yRUls=";
  };

  cargoHash = "sha256-+X2Kub/+6DZ6Un9FzAAlCMtQ7VCGqElqgtyTyjxpCRM=";

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
    }" $out/bin/brush
  '';

  # nativeInstallCheckInputs = [
  #   versionCheckHook
  # ];
  # doInstallCheck = true;

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
    mainProgram = "brush";
  };
})
