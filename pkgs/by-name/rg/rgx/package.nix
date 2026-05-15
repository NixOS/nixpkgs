{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pcre2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgx";
  version = "scode-v0.4.0";

  src = fetchFromGitHub {
    owner = "brevity1swos";
    repo = "rgx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3hVKz9MS4hBj0+10Jxau0CnxtT1TIyknZQJAkmlhHLU=";
  };

  cargoHash = "sha256-fzBVaN+nVv/H36m2uVwrudH3u4f63x7g7LuV0XQu6ns=";

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
