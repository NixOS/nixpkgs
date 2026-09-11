{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "sourcey";
  version = "3.6.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sourcey";
    repo = "sourcey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l1MpeJKGlQfiLCtCNMlG6ZEDYYLTMIy+N9sddDkxKXc=";
  };

  npmDepsHash = "sha256-Wwa7//iSvBmLCogVqk8aAUX9kn9FZsndvX00JBoXI+0=";

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
