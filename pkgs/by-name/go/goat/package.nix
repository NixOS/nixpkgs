{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "goat";
  version = "0-unstable-2024-07-31"; # Upstream currently isn't doing tags/releases.

  src = fetchFromGitHub {
    owner = "blampe";
    repo = "goat";
    rev = "177de93b192b8ffae608e5d9ec421cc99bf68402";
    hash = "sha256-/DR6RN7dCROp18P7dgm4DMppwdtYl0AOVNMEtXz8ldk=";
  };

  vendorHash = "sha256-24YllmSUzRcqWbJ8NLyhsJaoGG2+yE8/eXX6teJ1nV8=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Go ASCII Tool. Render ASCII art as SVG diagrams";
    homepage = "https://github.com/blampe/goat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "goat";
    platforms = lib.platforms.unix;
  };
}
