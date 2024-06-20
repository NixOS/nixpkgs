{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, redocly
, testers
}:

buildNpmPackage rec {
  pname = "redocly";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "Redocly";
    repo = "redocly-cli";
    rev = "@redocly/cli@${version}";
    hash = "sha256-qGjFueL05f7DgDa0/B+w1Ix2tRx7PicMneub2sWJ7Gw=";
  };

  npmDepsHash = "sha256-pO1ewVInuPCLDk2V4HRqOCFmT1VTVa/qRkJ5rxREWMU=";

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
      --set-default CI true # Silence update messages

    # Symlink for backwards compatibility. Remove after 24.05.
    ln -s $out/bin/redocly $out/bin/redocly-cli
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = redocly;
    };
  };

  meta = {
    description = "Makes OpenAPI easy. Lint/validate to any standard, generate beautiful docs, and more";
    homepage = "https://github.com/Redocly/redocly-cli";
    license = lib.licenses.mit;
    mainProgram = "redocly";
    maintainers = with lib.maintainers; [ szlend ];
  };
}
