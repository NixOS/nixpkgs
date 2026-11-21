{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (self: {
  pname = "nix-secrets-activate-unwrapped";
  version = "0.5.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unnamed-systems";
    repo = "nix-secrets";
    tag = "v${self.version}";
    hash = "sha256-MIltvL1t7PQsZhrqJHkBCSxHyuXVcZq6wls0ahIQB/4=";
  };
  cargoBuildFlags = [
    "-p"
    "nix-secrets-activate"
  ];
  cargoTestFlags = [
    "-p"
    "nix-secrets-activate"
  ];

  cargoHash = "sha256-qbKeNtChA54AuYYUB2UZwgspJi6ndzr7MoW/FgXmwY8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Postmodern secrets manager for NixOS, activation stage";
    homepage = "https://github.com/unnamed-systems/nix-secrets";
    license = lib.licenses.eupl12;
    maintainers = [
      lib.maintainers.bananad3v
      lib.maintainers.yunfachi
    ];
    platforms = lib.platforms.all;
    mainProgram = "nix-secrets-activate";
  };
})
