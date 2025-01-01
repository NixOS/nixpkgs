{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  redocly,
  testers,
}:

buildNpmPackage rec {
  pname = "redocly";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "Redocly";
    repo = "redocly-cli";
    rev = "@redocly/cli@${version}";
    hash = "sha256-jBfAMrmJ9+k1Fx2gZoQ8UiTT13tSvxXUKXNCW3vmuUY=";
  };

  npmDepsHash = "sha256-IcyX+LmMduE8CY6wNSTv0D4c3vCZu48EXsUSsqfOqFQ=";

  npmBuildScript = "prepare";

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    npm --prefix packages/cli run copy-assets
  '';

  postInstall = ''
    rm $out/lib/node_modules/@redocly/cli/node_modules/@redocly/{cli,openapi-core}
    cp -R packages/cli $out/lib/node_modules/@redocly/cli/node_modules/@redocly/cli
    cp -R packages/core $out/lib/node_modules/@redocly/cli/node_modules/@redocly/openapi-core

    mkdir $out/bin
    makeWrapper $out/lib/node_modules/@redocly/cli/node_modules/@redocly/cli/bin/cli.js \
      $out/bin/redocly \
      --set-default REDOCLY_TELEMETRY off \
      --set-default REDOCLY_SUPPRESS_UPDATE_NOTICE true
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = redocly;
    };
  };

  meta = {
    changelog = "https://redocly.com/docs/cli/changelog/";
    description = "Makes OpenAPI easy. Lint/validate to any standard, generate beautiful docs, and more";
    homepage = "https://github.com/Redocly/redocly-cli";
    license = lib.licenses.mit;
    mainProgram = "redocly";
    maintainers = with lib.maintainers; [ szlend ];
  };
}
