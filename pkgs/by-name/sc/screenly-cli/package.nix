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
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-sRi0CpdaPCH54m2XojicARLXZELB4PFcLLw0KB0j6jE=";
  };

  cargoHash = "sha256-U9NAfColVKbLsEf3HXS4Vu2eNvCjG0+koESFUWP9vMk=";

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
      jnsgruk
      vpetersson
    ];
  };
}
