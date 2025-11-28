{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "goat";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "blampe";
    repo = "goat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/m9qRTVrak+C4Df5y+36Ff7E0TdwHVbQEyrP+qfNF6E=";
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
