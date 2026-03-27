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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wxmM69bUp98CS4oCYhaliH7fRts9+Ay/JjhuP5IMgeE=";
  };

  cargoHash = "sha256-lnv0nCyb2+7Xl+qAAeaHdbk4XOGdq4FINxPOIPchDhg=";

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
