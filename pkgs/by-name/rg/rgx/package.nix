{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pcre2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgx";
  version = "0.14.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "brevity1swos";
    repo = "rgx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4ubPvcxRjwIbPsnxEu6QXPflPUJRnij8WIKeFT+Jxkg=";
  };

  cargoHash = "sha256-u0qCt/XwCayAOKDwD+nQiy41F/x6HORZmqzgpTsBdzM=";

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
