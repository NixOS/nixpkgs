{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "ccusage";
  version = "15.2.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/ccusage/-/ccusage-${version}.tgz";
    hash = "sha256-rMRHWSeGN+xiKp89VF0NiKUWbBxFFWEO3nhSeQlq4DM=";
  };

  npmDepsHash = "sha256-RScXn3Ry2lVXc57Sj/4OM9h51ddcU/v6cSLi6ecp4r8=";
  forceEmptyCache = true;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;
  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/ccusage
    cp -r * $out/lib/node_modules/ccusage/

    mkdir -p $out/bin
    ln -s $out/lib/node_modules/ccusage/dist/index.js $out/bin/ccusage
    chmod +x $out/lib/node_modules/ccusage/dist/index.js

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # Create a temporary mock Claude data directory structure for testing
    export TMPDIR_CLAUDE=$(mktemp -d)
    mkdir -p "$TMPDIR_CLAUDE/projects"

    # Set CLAUDE_CONFIG_DIR to point to our mock directory
    export CLAUDE_CONFIG_DIR="$TMPDIR_CLAUDE"

    # Test that the binary exists and can show help
    $out/bin/ccusage --help > /dev/null
    echo "ccusage help command executed successfully"

    # Test version command if available
    $out/bin/ccusage --version > /dev/null || echo "Version command not available, help test passed"

    # Cleanup temporary directory
    rm -rf "$TMPDIR_CLAUDE"

    runHook postInstallCheck
  '';

  meta = {
    description = "CLI tool for analyzing Claude Code token usage and costs from local JSONL files";
    homepage = "https://ccusage.com";
    changelog = "https://github.com/ryoppippi/ccusage/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yasunori0418 ];
    mainProgram = "ccusage";
  };
}
