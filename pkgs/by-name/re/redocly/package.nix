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
  version = "2.46.0";

  src = fetchFromGitHub {
    owner = "Redocly";
    repo = "redocly-cli";
    rev = "@redocly/cli@${version}";
    hash = "sha256-IdMeWY3MXHHoejWh2ZcskdzhUn0Ez3S9oxRx1uTKAWc=";
  };

  npmDepsHash = "sha256-62S71SBbSSADzzHapCmY2r98bLmRbokaxZU5l1x1cFA=";

  npmBuildScript = "prepare";

  # The CLI is bundled into packages/cli/lib by the `prepare` script (esbuild,
  # self-contained). That output directory is git-ignored, so `npm pack` drops
  # it during install; copy it back into the installed package.
  postInstall = ''
    cliDir="$out/lib/node_modules/@redocly/cli/packages/cli"
    cp -R packages/cli/lib "$cliDir/lib"

    # Create a wrapper script to force the correct command name (Nodejs uses argv[1] for command name)
    mkdir -p $out/bin
    cat <<EOF > $out/bin/redocly
    #!${lib.getBin nodejs}/bin/node
    // Override argv[1] to show "redocly" instead of "cli.js"
    process.argv[1] = 'redocly';

    // Set environment variables directly
    process.env.REDOCLY_TELEMETRY = process.env.REDOCLY_TELEMETRY || "off";
    process.env.REDOCLY_SUPPRESS_UPDATE_NOTICE = process.env.REDOCLY_SUPPRESS_UPDATE_NOTICE || "true";

    import('$cliDir/bin/cli.js');
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
