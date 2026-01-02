{
  fetchFromGitHub,
  lib,
  perl,
  pkg-config,
  openssl,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "screenly-cli";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-OSol+KVfxL/bz9qwT9u8MmjPQ11qqFYWnVQLXfcA6pQ=";
  };

  cargoHash = "sha256-znob9SvnE1y9yX/tTJY7jjJx/TnLTmoRRokScj5H1Yg=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for managing digital signs and screens at scale";
    homepage = "https://github.com/Screenly/cli";
    changelog = "https://github.com/Screenly/cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "screenly";
    maintainers = with lib.maintainers; [
      vpetersson
    ];
  };
}
