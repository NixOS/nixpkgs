{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-track";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NXEX2C2UhXmzyhN8jfqkv3d028axR1KIuXU94EPUmrU=";
  };

  cargoHash = "sha256-AbT0r6T2+ag70zEMjN3/2AMK1DfVkLfLAbG9puchD58=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Track where Nixpkgs pull requests have reached";
    homepage = "https://github.com/uncenter/nixpkgs-track";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-track";
    maintainers = with lib.maintainers; [
      isabelroses
      uncenter
      matthiasbeyer
    ];
  };
})
