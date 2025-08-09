{
  lib,
  nodejs,
  buildNpmPackage,
  fetchFromGitHub,
  redocly,
  testers,
}:

buildNpmPackage rec {
  pname = "redocly";
  version = "1.34.4";

  src = fetchFromGitHub {
    owner = "Redocly";
    repo = "redocly-cli";
    rev = "@redocly/cli@${version}";
    hash = "sha256-iGgttEJJI8FHAU+ZF4ZiTH/6FMCWZyF66ntq4MhLvnc=";
  };

  npmDepsHash = "sha256-nltS5exGhrZU/xBzTaQiWK0nIzU0ig+/nll0JSaloKE=";

  npmBuildScript = "prepare";

  postBuild = ''
    npm --prefix packages/cli run copy-assets
  '';

  postInstall = ''
    rm $out/lib/node_modules/@redocly/cli/node_modules/@redocly/{cli,openapi-core,respect-core}
    cp -R packages/cli $out/lib/node_modules/@redocly/cli/node_modules/@redocly/cli
    cp -R packages/core $out/lib/node_modules/@redocly/cli/node_modules/@redocly/openapi-core
    cp -R packages/respect-core $out/lib/node_modules/@redocly/cli/node_modules/@redocly/respect-core

    # Create a wrapper script to force the correct command name (Nodejs uses argv[1] for command name)
    mkdir -p $out/bin
    cat <<EOF > $out/bin/redocly
    #!${lib.getBin nodejs}/bin/node
    // Override argv[1] to show "redocly" instead of "cli.js"
    process.argv[1] = 'redocly';

    // Set environment variables directly
    process.env.REDOCLY_TELEMETRY = process.env.REDOCLY_TELEMETRY || "off";
    process.env.REDOCLY_SUPPRESS_UPDATE_NOTICE = process.env.REDOCLY_SUPPRESS_UPDATE_NOTICE || "true";

    require('$out/lib/node_modules/@redocly/cli/node_modules/@redocly/cli/bin/cli.js');
    EOF
    chmod +x $out/bin/redocly
  '';

  passthru = {
    tests.version = testers.testVersion { package = redocly; };
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
