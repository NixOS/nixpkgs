{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ferron";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "ferronweb";
    repo = "ferron";
    tag = finalAttrs.version;
    hash = "sha256-va9OUI2jQiJ3K/Cq3Wrh7RmMST3dBJLB5REcqp7WRP0=";
  };

  # ../../ is cargoDepsCopy, and obviously does not contain monoio's README.md
  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/monoio-0.2.4/src/lib.rs \
      --replace-fail '#![doc = include_str!("../../README.md")]' ""
  '';

  cargoHash = "sha256-cOkZ8WVcgfIrwEBAGN/U3qp9VZl5S78Bmrpe4nxn994=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast, memory-safe web server written in Rust";
    homepage = "https://github.com/ferronweb/ferron";
    changelog = "https://github.com/ferronweb/ferron/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      _0x4A6F
      GaetanLepage
    ];
    mainProgram = "ferron";
  };
})
