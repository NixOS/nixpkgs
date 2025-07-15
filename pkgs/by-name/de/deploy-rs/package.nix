{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "0-unstable-2025-06-05";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "6bc76b872374845ba9d645a2f012b764fecd765f";
    hash = "sha256-hXh76y/wDl15almBcqvjryB50B0BaiXJKk20f314RoE=";
  };

  cargoHash = "sha256-9O93YTEz+e2oxenE0gwxsbz55clbKo9+37yVOqz7ErE=";

  meta = {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      teutat3s
      jk
    ];
    teams = [ lib.teams.serokell ];
    mainProgram = "deploy";
  };
}
