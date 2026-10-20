{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "sourcey";
  version = "3.8.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sourcey";
    repo = "sourcey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tvjkBJiHbk0zBBsLCXB7mKLy/eeG4V31laLajSTZ5IE=";
  };

  npmDepsHash = "sha256-gV/XfxuaZ+W7ByQvTwF0+YgoE8942V4X9OcXV5HmOO8=";

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
