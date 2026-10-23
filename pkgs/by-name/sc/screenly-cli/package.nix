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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w8aEga+DoEUr9KV079RjQHKMx2253DS6cKDzyGWCdZI=";
  };

  cargoHash = "sha256-2T3/9DtW43OwjMTeqmR4Bg8miu245DhAS+pQbx85k24=";

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
