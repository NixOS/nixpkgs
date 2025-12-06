{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alistral";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "RustyNova016";
    repo = "Alistral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lbdyE/k28fJzrOQEKDL8ZLnm6tNcAM4tsfHpcGlJB9s=";
  };

  cargoHash = "sha256-smoUGJSMmRKdnUz4L+LvPOH/A6CHVmkiHxdyesu+BTw=";

  buildNoDefaultFeatures = true;
  # Would be cleaner with an "--all-features" option
  buildFeatures = [ "full" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Wants to create config file where it s not allowed
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://rustynova016.github.io/Alistral/";
    changelog = "https://github.com/RustyNova016/Alistral/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Power tools for Listenbrainz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jopejoe1
      RustyNova
    ];
    mainProgram = "alistral";
  };
})
