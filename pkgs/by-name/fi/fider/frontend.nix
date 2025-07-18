{
  buildNpmPackage,

  pname,
  version,
  src,
  npmDepsHash,
}:

buildNpmPackage {
  inherit version src npmDepsHash;
  pname = "${pname}-frontend";

  buildPhase = ''
    runHook preBuild

    npx lingui extract public/
    npx lingui compile
    NODE_ENV=production node esbuild.config.js
    NODE_ENV=production npx webpack-cli

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist ssr.js favicon.png robots.txt $out/

    runHook postInstall
  '';

  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;
  };
}
