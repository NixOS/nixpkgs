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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HycVA5Eln/9w4PC3FnULvpVXlN1HLOcWsokVLN6ReKQ=";
  };

  cargoHash = "sha256-DOQSRRY/ZR4VcHN666Sk8MhJgED61IYzBZTlc37O/M0=";

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
