{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pcre2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgx";
  version = "0.12.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "brevity1swos";
    repo = "rgx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-01JnU+vDkEIYrEhl9KUGZx2+p2Xw76qjI9mpGsaTPLA=";
  };

  cargoHash = "sha256-ZjfLh+vYlKP0JLxLvnkB9Qr3aQ/Oki/KvQmjCF7G1Mg=";

  buildInputs = [ pcre2 ];

  buildFeatures = [ "pcre2-engine" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    homepage = "https://github.com/brevity1swos/rgx";
    description = "Terminal regex tester with real-time matching and multi-engine support";
    changelog = "https://github.com/brevity1swos/rgx/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      Cameo007
      kybe236
    ];
    mainProgram = "rgx";
  };
})
