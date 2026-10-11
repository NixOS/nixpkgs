{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "sourcey";
  version = "3.6.12";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sourcey";
    repo = "sourcey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S7gK66626h+kt3BtmMff0KslFzXEIhg0CSACARsUrqs=";
  };

  npmDepsHash = "sha256-29O9PaOGbuTWD001xYyDdJKkRSzSfR2ow9cAHeQcObw=";

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
