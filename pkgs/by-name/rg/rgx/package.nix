{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pcre2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgx";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "brevity1swos";
    repo = "rgx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JLFJGMwKQqkrVwck6gd79AzSVL0fRHJ8jo73+EEdYlA=";
  };

  cargoHash = "sha256-D609cDiJ+L/iGtC9dKwU5dgz4+X3//6qiFjWixBBqhg=";

  buildInputs = [ pcre2 ];

  buildFeatures = [ "pcre2-engine" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/brevity1swos/rgx";
    description = "Terminal regex tester with real-time matching and multi-engine support";
    changelog = "https://github.com/brevity1swos/rgx/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "rgx";
  };
})
