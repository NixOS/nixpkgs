{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ktea";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jonas-grgt";
    repo = "ktea";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MAE0ILiZHKKgYEoovOvLymjsxVKCrUxXoyHpK3kxzLs=";
  };

  vendorHash = "sha256-bw8vjb4ih7gjpoFPorg1GFGrHw2gHW0AyMD0thiAfVw=";

  subPackages = [ "cmd/ktea" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kafka TUI client";
    homepage = "https://github.com/jonas-grgt/ktea";
    changelog = "https://github.com/jonas-grgt/ktea/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "ktea";
  };
})
