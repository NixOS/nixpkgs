{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pcre2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgx";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "brevity1swos";
    repo = "rgx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-05WEJ3gefPjBHuMXWhr135VtYnbteZapiAtNKwm4wxU=";
  };

  cargoHash = "sha256-CSGuf2jOjyLBfD0Fv3G01FioiyiXX8Bx/IiCkIBWbsQ=";

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
