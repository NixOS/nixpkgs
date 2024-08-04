{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}: let
  pname = "git-upstream";
  version = "1.1.0";
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "9999years";
      repo = pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-Pq0Z1WwrTP7dCwk6V/E0zu9sLLWr3kNuT3aJRZuRzhI=";
    };

    cargoHash = "sha256-jNpleFrOvt1m2TXTeBXfhTSjWNpCknNoKooF2xsO46w=";

    meta = with lib; {
      homepage = "https://github.com/9999years/git-upstream";
      changelog = "https://github.com/9999years/git-upstream/releases/tag/v${version}";
      description = "Shortcut for `git push --set-upstream`";
      license = [licenses.mit];
      maintainers = [maintainers._9999years];
      mainProgram = "git-upstream";
    };

    passthru.updateScript = nix-update-script {};
  }
