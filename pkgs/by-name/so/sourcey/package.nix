{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "sourcey";
  version = "3.3.10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sourcey";
    repo = "sourcey";
    tag = finalAttrs.version;
    hash = "sha256-ByvcCxjxNzmQVzNIPZTY/RPrGyd7RDPTpCvYtkaqazs=";
  };

  npmDepsHash = "sha256-jdzOCeFoUcjmaJz1h4i1utWdFwcfcDmtTkfj+EGXVtI=";

  npmDepsFetcherVersion = 2;

  makeCacheWritable = true;

  npmFlags = [ "--legacy-peer-deps" ];

  dontNpmBuild = true;

  meta = {
    description = "Open source documentation platform for OpenAPI specs and markdown";
    homepage = "https://sourcey.com";
    license = lib.licenses.agpl3Only;
    mainProgram = "sourcey";
    maintainers = with lib.maintainers; [ auscaster ];
  };
})
