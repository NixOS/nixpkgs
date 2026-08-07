{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage (finalAttrs: {
  pname = "spectral";
  version = "6.16.3";

  __structuredAttrs = true;

  # Spectral is a pnpm monorepo without a committed lockfile, so building the
  # CLI from the GitHub source is impractical. Fetch the published npm tarball
  # (which ships the prebuilt `dist/`) and install only its runtime deps.
  src = fetchurl {
    url = "https://registry.npmjs.org/@stoplight/spectral-cli/-/spectral-cli-${finalAttrs.version}.tgz";
    hash = "sha256-EuFegY26qKFI+nIDDl+fm4egODeUybX46TT2PdEqlfI=";
  };

  # The npm tarball has no lockfile; a prod-only one is generated and vendored.
  # Drop devDependencies and the (monorepo-relative) lifecycle scripts so
  # `npm ci` stays in sync with the vendored, production-only lockfile.
  # `node` is only present in the main build (not in the npmDeps fetcher, which
  # merely reads the lockfile), so guard the package.json rewrite on it.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    if command -v node >/dev/null; then
      node -e 'const fs=require("fs");const p=require("./package.json");delete p.devDependencies;p.scripts={};fs.writeFileSync("package.json",JSON.stringify(p,null,2));'
    fi
  '';

  npmDepsHash = "sha256-kroboXrukYGZCw1wqiA0+cvWS36GLxKZFE+jMKIMOoM=";

  dontNpmBuild = true;
  npmFlags = [ "--ignore-scripts" ];

  meta = {
    description = "JSON/YAML linter with OpenAPI/AsyncAPI support";
    homepage = "https://github.com/stoplightio/spectral";
    changelog = "https://github.com/stoplightio/spectral/releases/tag/@stoplight/spectral-cli-${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "spectral";
    maintainers = with lib.maintainers; [ tembleking ];
  };
})
