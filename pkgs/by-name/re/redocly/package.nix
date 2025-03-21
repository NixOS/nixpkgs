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
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "Redocly";
    repo = "redocly-cli";
    rev = "@redocly/cli@${version}";
    hash = "sha256-1iyE0LYbVEleCdSw6fWvIHqCkWMEZrjK6tum+qytcCY=";
  };

  npmDepsHash = "sha256-TIsVjdohsmvAAn9xQeeD5pu4CjXtYlD7bmKeDp113Lc=";

  npmBuildScript = "prepare";

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    npm --prefix packages/cli run copy-assets
  '';

  postInstall = ''
    rm $out/lib/node_modules/@redocly/cli/node_modules/@redocly/{cli,openapi-core,respect-core}
    cp -R packages/cli $out/lib/node_modules/@redocly/cli/node_modules/@redocly/cli
    cp -R packages/core $out/lib/node_modules/@redocly/cli/node_modules/@redocly/openapi-core
    cp -R packages/respect-core $out/lib/node_modules/@redocly/cli/node_modules/@redocly/respect-core

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
