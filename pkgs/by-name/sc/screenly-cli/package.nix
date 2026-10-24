{
  fetchFromGitHub,
  lib,
  perl,
  pkg-config,
  openssl,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "screenly-cli";
  version = "26.9.0";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WFL95MT9XXBaA+rwnCGGTYOugP57lWV60J93IlHUts4=";
  };

  cargoHash = "sha256-OZmf5+XoZfD5YL2psko8NGf2+1R1FWuUNKSJGBjsVUs=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for managing digital signs and screens at scale";
    homepage = "https://github.com/Screenly/cli";
    changelog = "https://github.com/Screenly/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "screenly";
    maintainers = with lib.maintainers; [
      vpetersson
    ];
  };
})
