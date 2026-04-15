{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pcre2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgx";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "brevity1swos";
    repo = "rgx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lZA8Tfyneg8cnBeCf0abgPr9232a1OGBfOJEBnU2l+s=";
  };

  cargoHash = "sha256-DOIQaqoUkR1KpQURC89PRds0wJkroSYufbKz62rjSB4=";

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
