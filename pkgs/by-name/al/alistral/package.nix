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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "RustyNova016";
    repo = "Alistral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ot8FvHDsW8pA4U1Ul4gNiBhDDTN/sRmrCShCySrTORQ=";
  };

  cargoHash = "sha256-BfGR4Y9Tn5QtXfGirZ2UsUzhJ7rCfpxkNM83pHls7u8=";

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
