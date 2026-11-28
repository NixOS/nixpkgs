{
  buildNpmPackage,
  nodejs_22,
  src,
  version,
}:

buildNpmPackage {
  pname = "artemis-frontend";
  inherit src version;
  __structuredAttrs = true;

  sourceRoot = "${src.name}/apps/showcase_ui";
  nodejs = nodejs_22;

  npmDepsHash = "sha256-ePlGYp0z+EqrzKsd2zunETi7lE6MMOIm2czts9n9dzU=";

  postPatch = ''
    # This downloads google fonts during the build
    substituteInPlace angular.json \
      --replace-fail '"outputHashing": "all"' \
        '"outputHashing": "all", "optimization": {"scripts": true, "styles": true, "fonts": false}'
  '';

  env.NG_CLI_ANALYTICS = "false";

  installPhase = ''
    runHook preInstall
    cp -r dist/frontend/browser "$out"
    cp dist/frontend/3rdpartylicenses.txt "$out/"
    runHook postInstall
  '';
}
