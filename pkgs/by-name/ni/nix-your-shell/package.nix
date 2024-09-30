{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "nix-your-shell";
    rev = "v${version}";
    hash = "sha256-FjGjLq/4qeZz9foA7pfz1hiXvsdmbnzB3BpiTESLE1c=";
  };

  cargoHash = "sha256-2NgN2/dr48ogkcjOq6UE4jDQBeewceWzdpRlXqi744s=";

  meta = {
    mainProgram = "nix-your-shell";
    description = "`nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    changelog = "https://github.com/MercuryTechnologies/nix-your-shell/releases/tags/v${version}";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ _9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
