{
  lib,
  rustc,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  rustup,
  openssl,
  stdenv,
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-minimal-versions";
  version = "0.1.37";

  src = fetchFromGitHub {
    owner = "taiki-e";
    repo = "cargo-minimal-versions";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-zNZBFCb8wCOYl+ipE/E/2iDNECB8dC9ZO/CPoR2BSM4=";
  };

  # Upstream doesn't include the lockfile so we need to add it back
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "test-helper-0.0.0" = "sha256-Fr6KbCCx+b4AKUAVcNbG7HKktGei9atBVRou8/qAImk=";
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "Cargo subcommand for proper use of -Z minimal-versions and -Z direct-minimal-versions.";
    mainProgram = "cargo-minimal-versions";
    homepage = "https://github.com/taiki-e/cargo-minimal-versions";
    changelog = "https://github.com/taiki-e/cargo-minimal-versions/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ chrjabs ];
  };
})
