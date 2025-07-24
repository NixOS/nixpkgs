{
  lib,
  src,
  buildNpmPackage,
  version,
}:
buildNpmPackage (finalAttrs: {
  inherit version src;
  pname = "go-foks-frontend";
  npmDepsHash = "sha256-mASu3taprCYP+muRh4b+qUTce7YTdISf/QnmSvUy6Mo=";
  npmPackFlags = [ "--ignore-scripts" ];
  # We only need to fetch the deps to be copied into the foks-server binary
  dontNpmBuild = true;
  NODE_OPTIONS = "--openssl-legacy-provider";
  meta = {
    description = "Web frontend to the Go FOKS implementation.";
    homepage = "https://github.com/foks-proj/go-foks";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ngp ];
  };
  sourceRoot = finalAttrs.src.name + "/server/web/frontend";
})
