{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  bun,
  gh,
  git,
  nodejs,
  nix-update-script,
  runtimeShell,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "ghui";
  version = "0.4.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kitlangton";
    repo = "ghui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jMi2Pc2VTpj0cZ2zXqtunG0FxcglCNEt9WzWnwxq+Js=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    fetcherVersion = finalAttrs.npmDepsFetcherVersion;
    hash = "sha256-GYGegGw80M5T2wETreP95OrCn7F7XxlZcZWy9TjbCHY=";
    nativeBuildInputs = [ nodejs ];
    prePatch = ''
      export HOME=$TMPDIR
      npm pkg set 'dependencies.@ghui/keymap=file:packages/keymap'
      npm pkg delete 'devDependencies.@ghui/keymap'
      npm install --package-lock-only --ignore-scripts --no-audit --no-fund
    '';
  };

  prePatch = ''
    export HOME=$TMPDIR
    # prefetch-npm-deps --map-cache reads npmDeps from the process environment.
    export npmDeps
    npm pkg set 'dependencies.@ghui/keymap=file:packages/keymap'
    npm pkg delete 'devDependencies.@ghui/keymap'
    cp ${finalAttrs.npmDeps}/package-lock.json package-lock.json
  '';

  nativeBuildInputs = [ bun ];

  npmDepsFetcherVersion = 3;

  npmFlags = [
    "--no-audit"
    "--no-fund"
  ];

  npmBuildScript = "build:cli";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstallCheck = ''
    cd $out/lib/ghui
    ${lib.getExe bun} -e '
      await import("@effect/atom-react")
      await import("@ghui/keymap")
      await import("@opentui/core")
      await import("@opentui/react")
      await import("effect")
      await import("react")
      await import("scheduler")
    '
  '';

  # The bundled CLI runs on Bun and resolves runtime dependencies from the
  # installed node_modules tree. gh is kept on PATH for GitHub API operations.
  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --no-save --no-audit --no-fund

    mkdir -p $out/lib/ghui $out/bin
    cp -r dist node_modules packages package.json README.md LICENSE .env.example $out/lib/ghui/
    rm -f $out/lib/ghui/node_modules/.bin/ghui

    cat > $out/bin/ghui <<'EOF'
    #!@runtimeShell@
    case "''${1-}" in
      -v|--version|version)
        echo @version@
        exit 0
        ;;
      -h|--help|help)
        printf '%s\n' \
          "ghui @version@" \
          "" \
          "Terminal UI for GitHub pull requests." \
          "" \
          "Usage:" \
          "  ghui              Start the TUI" \
          "  ghui -v, --version" \
          "                    Print the installed version" \
          "  ghui -h, --help   Show this help message"
        exit 0
        ;;
    esac

    export PATH=@path@:$PATH
    exec @bun@ "@out@/lib/ghui/dist/index.js" "$@"
    EOF
    substituteInPlace $out/bin/ghui \
      --replace-fail @runtimeShell@ ${runtimeShell} \
      --replace-fail @version@ ${finalAttrs.version} \
      --replace-fail @path@ ${
        lib.makeBinPath [
          gh
          git
        ]
      } \
      --replace-fail @bun@ ${lib.getExe bun} \
      --replace-fail @out@ $out
    chmod +x $out/bin/ghui

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI for GitHub pull requests";
    homepage = "https://github.com/kitlangton/ghui";
    changelog = "https://github.com/kitlangton/ghui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kitlangton ];
    mainProgram = "ghui";
    platforms = bun.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
