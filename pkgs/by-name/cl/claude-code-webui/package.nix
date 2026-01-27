{
  lib,
  claude-code,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_latest,
  deno,
  python3,
  git,
}:

let
  version = "0.1.56";
  nodejs = nodejs_latest;

  frontend = buildNpmPackage rec {
    pname = "claude-code-webui-frontend";
    inherit version;

    src = fetchFromGitHub {
      owner = "sugyan";
      repo = "claude-code-webui";
      rev = version;
      hash = "sha256-KFGLk9GH3IlmwC1eBNtfpEJ6plX7NtxuxTXuj1lwlos=";
    };

    sourceRoot = "source/frontend";

    inherit nodejs;

    npmDepsHash = "sha256-FCeGRQbgwFJQZ+Z/Gwz2abjYKxrpPva8fde69fu26C4=";

    buildPhase = ''
      runHook preBuild
      npm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist $out/
      runHook postInstall
    '';
  };

in
buildNpmPackage rec {
  pname = "claude-code-webui";
  inherit version;

  src = fetchFromGitHub {
    owner = "sugyan";
    repo = "claude-code-webui";
    rev = version;
    hash = "sha256-KFGLk9GH3IlmwC1eBNtfpEJ6plX7NtxuxTXuj1lwlos=";
  };

  sourceRoot = "source/backend";

  inherit nodejs;

  npmDepsHash = "sha256-ql2kuseCT/i54qWxIB7HXm19u1VUtqdhOftvyr46up4=";

  preBuild = ''
    # Set HOME for Deno (not needed for npm build)
    export HOME=$TMPDIR
  '';

  buildPhase = ''
    runHook preBuild

    # Generate version
    node scripts/generate-version.js

    # Build clean and bundle
    npm run build:clean
    npm run build:bundle

    # Copy frontend files manually to avoid the script's path expectations
    mkdir -p dist/static
    cp -r ${frontend}/dist/* dist/static/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib

    # Copy the built backend dist and node_modules
    cp -r dist $out/lib/
    cp -r node_modules $out/lib/

    # Create the main executable
    cat > $out/bin/claude-code-webui <<EOF
    #!${nodejs}/bin/node
    const path = require('path');
    const fs = require('fs');

    const mainScript = path.join('$out', 'lib', 'dist', 'cli', 'node.js');

    if (fs.existsSync(mainScript)) {
      require(mainScript);
    } else {
      console.error('claude-code-webui main script not found at:', mainScript);
      process.exit(1);
    }
    EOF

    chmod +x $out/bin/claude-code-webui
    runHook postInstall
  '';

  # Runtime dependencies
  nativeBuildInputs = [
    deno
    python3
    git
  ];

  # This package depends on claude-code at runtime
  passthru.dependencies = [ claude-code ];

  meta = with lib; {
    description = "Web-based interface for the Claude Code CLI with streaming chat interface";
    homepage = "https://github.com/sugyan/claude-code-webui";
    changelog = "https://github.com/sugyan/claude-code-webui/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ luochen1990 ];
    mainProgram = "claude-code-webui";
    platforms = platforms.unix;
  };
}
