{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  versionCheckHook,
  rustc,
  nix-update-script,
  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "freenet-core";
  version = "0.2.106";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "freenet";
    repo = "freenet-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mYGBsWgju2DVACk+usSCAXJ14PzAUqabiOkoW1dN6mM=";
  };

  cargoHash = "sha256-n+Tj1zrCzAZ/7k+ZK9Wbw1L9xXZhkrOtGudZFvcDdPo=";

  # No upstream fix exists yet; see https://github.com/freenet/freenet-core/issues/4935.
  patches = [ ./use-source-date-epoch.patch ];

  cargoBuildFlags = [ "--package=freenet" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # So many of the tests require network connectivity that it isn't
  # worth trying to skip specific ones
  doCheck = false;

  passthru = {
    tests = {
      inherit (nixosTests) freenet-core;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Peer-to-peer platform for decentralized applications";
    homepage = "https://freenet.org/";
    donationPage = "https://freenet.org/donate/";
    changelog = "https://github.com/freenet/freenet-core/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = [
      lib.maintainers.skyesoss
      lib.maintainers.LisaScheers
    ];
    mainProgram = "freenet";
    inherit (rustc.meta) platforms;
  };
})
