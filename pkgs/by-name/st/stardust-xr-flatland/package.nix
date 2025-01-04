{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-flatland";
  version = "0-unstable-2024-09-09";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "flatland";
    rev = "0914dd3df54a5e6258dfc0a02d65af1c0fc0fc90";
    hash = "sha256-rDBQ9tXQCCA7emikSYH59ADJELE2IpzB7eoLrpHYzU4=";
  };

  env.STARDUST_RES_PREFIXES = "${src}/res";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "stardust-xr-0.45.0" = "sha256-6+L9WQWrHot+Pm+iZ9oq8DOK3AzaDpP7pUjpaq3zH3c=";
      "stardust-xr-molecules-0.45.0" = "sha256-aOZUbKdICzkZwJYYz7J4M3BIyoLmUGouVCkM+KFQsMc=";
    };
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "A flat window for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "flatland";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
