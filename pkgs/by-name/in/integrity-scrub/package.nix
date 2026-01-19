{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "integrity-scrub";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "illdefined";
    repo = "integrity-scrub";
    tag = version;
    hash = "sha256-OLO64R9AYpHSkIwk2arka5EEzCWusZPWsBhy5HEDIQI=";
  };

  cargoHash = "sha256-sS4z5NImUdk0EnQ+BGPofFZtXZsomfUXXbHNDmVqAos=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  # Requires unstable features
  env.RUSTC_BOOTSTRAP = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/illdefined/integrity-scrub";
    description = "Scrub dm-integrity devices";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = lib.platforms.linux;
    mainProgram = "integrity-scrub";
  };
}
