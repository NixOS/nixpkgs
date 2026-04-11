{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pcre2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgx";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "brevity1swos";
    repo = "rgx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H566bgnf4bNPXS7rPtOFTlqmkwoXKbB1fBmFDZQUjac=";
  };

  cargoHash = "sha256-hTR4eZKUOxvib5lAV/l76GZQPQ6s+Hgl3DT2kaGlaGg=";

  buildInputs = [ pcre2 ];

  buildFeatures = [ "pcre2-engine" ];

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
