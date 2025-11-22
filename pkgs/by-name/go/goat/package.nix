{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "goat";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "blampe";
    repo = "goat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/DR6RN7dCROp18P7dgm4DMppwdtYl0AOVNMEtXz8ldk=";
  };

  vendorHash = "sha256-24YllmSUzRcqWbJ8NLyhsJaoGG2+yE8/eXX6teJ1nV8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go ASCII Tool. Render ASCII art as SVG diagrams";
    homepage = "https://github.com/blampe/goat";
    changelog = "https://github.com/blampe/goat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "goat";
    platforms = lib.platforms.unix;
  };
})
