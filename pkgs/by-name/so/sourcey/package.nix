{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "sourcey";
  version = "3.6.11";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sourcey";
    repo = "sourcey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-on34Zj6regW2KfvvgmDy0Cvi5paNWRBaXPDfHWAcypw=";
  };

  npmDepsHash = "sha256-QRNrV/2nRfwU8VcapjDcuQbZFpO0R2J4D4ji+0hQCLk=";

  npmDepsFetcherVersion = 2;

  makeCacheWritable = true;

  npmFlags = [ "--legacy-peer-deps" ];

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source documentation platform for OpenAPI specs and markdown";
    homepage = "https://sourcey.com";
    license = lib.licenses.agpl3Only;
    mainProgram = "sourcey";
    maintainers = with lib.maintainers; [ auscaster ];
  };
})
