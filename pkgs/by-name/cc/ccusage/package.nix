{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  testers,
  ccusage,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccusage";
  version = "15.3.1";

  src = fetchFromGitHub {
    owner = "ryoppippi";
    repo = "ccusage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3FAW0R6Q0Uw9fn5c4Z+H3jnC5xLtatOz5l/FbHm/258=";
  };

  nativeBuildInputs = [ nodejs ];
  buildInputs = [ nodejs ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$TMPDIR
    export npm_config_cache=$TMPDIR/.npm
    export npm_config_fund=false
    export npm_config_audit=false

    # Remove problematic workspace references
    substituteInPlace package.json \
      --replace-fail $'\t\t"docs"' ""

    # Remove git hooks that interfere with the build process
    substituteInPlace package.json \
      --replace-fail '"simple-git-hooks": "^2.13.0",' "" \
      --replace-fail '"lint-staged": "^16.1.2",' "" \
      --replace-fail '"prepare": "simple-git-hooks",' ""

    # Clean up git hooks configuration sections
    sed -i '/"simple-git-hooks"/,/},/d' package.json
    sed -i '/"lint-staged"/,/},/d' package.json

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Install dependencies
    npm install --ignore-scripts

    # Build the project
    npm run build

    runHook postBuild
  '';

  installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/lib/node_modules/ccusage

        # Copy built files and essential package files
        cp -r dist $out/lib/node_modules/ccusage/
        cp package.json $out/lib/node_modules/ccusage/

        # Create executable wrapper
        cat > $out/bin/ccusage << 'EOF'
    #!/usr/bin/env node
    require('$out/lib/node_modules/ccusage/dist/index.js');
    EOF

        chmod +x $out/bin/ccusage

        runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = ccusage;
      command = "ccusage --version";
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "CLI tool for analyzing Claude Code token usage and costs from local JSONL files";
    longDescription = ''
      ccusage is a fast and informative CLI tool that analyzes Claude Code usage data
      from local JSONL files. It provides detailed reports on token consumption, costs,
      and usage patterns with support for daily, monthly, and session-based analysis.

      Features include:
      - Token usage analysis with cost calculations
      - Multiple report formats (daily, monthly, session-based, billing blocks)
      - JSON and table output formats
      - Live monitoring capabilities
      - Model Context Protocol (MCP) server integration
    '';
    homepage = "https://github.com/ryoppippi/ccusage";
    changelog = "https://github.com/ryoppippi/ccusage/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ connerohnesorge ];
    mainProgram = "ccusage";
    platforms = lib.platforms.unix;
  };
})
