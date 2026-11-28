{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "podcast-dl";
  version = "12.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lightpohl";
    repo = "podcast-dl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-35JhO66biCxf5t6B+9pM8O67sohU6h5SLSHIJ1pP8vY=";
  };

  npmDepsHash = "sha256-0rN7DaWHIHOUY1a45Ee16UGFGble2oUv0ktpVVRDLM8=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A CLI for downloading podcasts";
    homepage = "https://github.com/lightpohl/podcast-dl";
    changelog = "https://github.com/lightpohl/podcast-dl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jecaro ];
    mainProgram = "podcast-dl";
    platforms = lib.platforms.all;
  };
})
