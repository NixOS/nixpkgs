{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "0-unstable-2025-12-18";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "d5eff7f948535b9c723d60cd8239f8f11ddc90fa";
    hash = "sha256-znKOwPXQnt3o7lDb3hdf19oDo0BLP4MfBOYiWkEHoik=";
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
