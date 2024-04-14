{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
}:

buildNpmPackage rec {
  pname = "redocly";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "Redocly";
    repo = "redocly-cli";
    rev = "@redocly/cli@${version}";
    hash = "sha256-KfNwBRGDFNMsba+yjwUHiiO2BJbIl4pW1b3cvLBe+lk=";
  };

  npmDepsHash = "sha256-I3cxMw9zOZb9sfP8UUoHc1UJ0RpDqVn9D29arSdNob4=";

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
      $out/bin/redocly-cli \
      --set-default REDOCLY_TELEMETRY off \
      --set-default CI true # Silence update messages
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/redocly-cli --version
    runHook postInstallCheck
  '';

  doInstallCheck = true;

  meta = {
    description = "Redocly CLI makes OpenAPI easy. Lint/validate to any standard, generate beautiful docs, and more.";
    homepage = "https://github.com/Redocly/redocly-cli";
    license = lib.licenses.mit;
    mainProgram = "redocly-cli";
    maintainers = with lib.maintainers; [ szlend ];
  };
}
