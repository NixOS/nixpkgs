{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "sourcey";
  version = "3.9.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sourcey";
    repo = "sourcey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xzboEu+WSog7vLr2dAgpTwaA9DOtw2yX0sn1aPl3gp8=";
  };

  npmDepsHash = "sha256-v/1AHYvTuy9m9WS2xCyWdKCkXrRe6LKx6RbwyiJ9RU4=";

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
