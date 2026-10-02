{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  inetutils,
  makeBinaryWrapper,
  nodejs,
  nix-update-script,
  ripgrep,
  gitMinimal,
  xdg-utils,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let

  nodeModules =
    finalAttrs:
    stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

        # Only fetch the cline CLI deps
        bun install \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress \
          --os="*" \
          --cpu="*" \
          --filter ./ \
          --filter './sdk/packages/*' \
          --filter ./apps/cli \
          --filter ./apps/cline-hub \
          --filter ./apps/cline-hub/src/webview

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        find . -type d -name node_modules -exec cp -R --parents {} $out \;

        runHook postInstall
      '';

      # Required, else the fixed-output derivation ends up referencing store
      # paths from the source it was built from.
      dontFixup = true;

      outputHash = "sha256-cDZ7Ad87n/IlVqOqRTrZjaPUMilHiP7g4M0/K5tRoyM=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };

  # Upstream's build script names its output directory after the platform it
  # compiled for, which with --single is always the build host.
  targetDirName =
    (if stdenvNoCC.hostPlatform.isDarwin then "cli-darwin-" else "cli-linux-")
    + (if stdenvNoCC.hostPlatform.isx86_64 then "x64" else "arm64");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cline";
  version = "3.0.65";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cline";
    repo = "cline";
    tag = "cli-v${finalAttrs.version}";
    hash = "sha256-9Mw9hFPVaAE833vfwqYDIHDa8bjIu+xUwQ5p7l7Fdm8=";
  };

  node_modules = nodeModules finalAttrs;

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    # tsc has a `#!/usr/bin/env node` shebang in its shims
    nodejs
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .

    # The store hands over a read-only tree, but the build writes into it:
    # `tsc -b` emits .tsbuildinfo files under node_modules/.tmp, and Vite
    # caches next to the packages it resolves.
    find . -type d -name node_modules -prune -exec chmod -R u+w {} +

    patchShebangs node_modules apps sdk

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Bundle everything into a standalone executable
    pushd apps/cli > /dev/null
    bun script/build.ts --single
    popd > /dev/null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dist="apps/cli/dist/${targetDirName}"

    mkdir -p $out/libexec/cline
    cp -R "$dist/." $out/libexec/cline/

    makeBinaryWrapper $out/libexec/cline/bin/cline $out/bin/cline \
      --set CLINE_NO_AUTO_UPDATE 1 \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            # agent's file search tool is backed by rg
            ripgrep
            # Checkpoints, worktrees, repo status and plugin installs all
            # call out to git
            gitMinimal
          ]
          ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
            # xdg-open, to put the dashboard in a browser.
            xdg-utils
          ]
        )
      }

    runHook postInstall
  '';

  # Bun-compiled executables do not survive stripping.
  dontStrip = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
    inetutils
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = "HOME PATH";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # CLI releases are tagged with `cli-v` prefix, e.g. `cli-v1.2.3`
      "--version-regex"
      "^cli-v"
      # Recompute FOD hash of the node_modules derivation as well
      "--subpackage"
      "node_modules"
    ];
  };

  meta = {
    description = "Autonomous coding agent CLI for the terminal";
    longDescription = ''
      Cline is an open-source autonomous AI coding agent that runs inside
      your editor or terminal. It reads files, writes code, runs terminal
      commands, and fixes errors while keeping you in control through structured
      plan-and-act steps.
    '';
    homepage = "https://cline.bot";
    changelog = "https://github.com/cline/cline/blob/main/apps/cli/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "cline";
    maintainers = with lib.maintainers; [ johnrtitor ];
    inherit (bun.meta) platforms;
  };
})
