{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "npingler";
  version = "unstable-2025-08-21";

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "npingler";
    rev = "de47bb5c5c188ba3b36958c2284dbc6d24f2687f";
    hash = "sha256-4Q8oG2iem9dgsTTEFfhyw2rPAxtXdGx+Uhb/9uAdUy4=";
  };

  cargoHash = "sha256-wTW0cwi6C2WRlH2ifPMTdLAEZg4VbE5Jr5Mh+e+SjaM=";

  meta = {
    description = "Nix profile manager for use with npins";
    homepage = "https://github.com/9999years/npingler";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "npingler";
  };

  passthru.updateScript = nix-update-script { };
}
