{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitLab,
  makeBinaryWrapper,
  nix-update-script,
  nodejs_22,
  ripgrep,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gitlab-duo";
  version = "9.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    group = "gitlab-org";
    owner = "editor-extensions";
    repo = "gitlab-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D4WNlmZeMG47Y6AHcwk38PFrO0NMX9mxM781Jy7YDFM=";
  };

  # Upstream migrated from npm to bun (bun.lock) in v8.90.0. Vendor the fully
  # resolved node_modules via a fixed-output derivation running `bun install`.
  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="*" \
        --os="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    # Required: keeping store paths out of the FOD output keeps the hash stable.
    dontFixup = true;

    outputHash = "sha256-SgLb1b43FJ8EYdRrdkpgA6MgYcAZD56e2u+4y3mKbpI=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    nodejs_22
    makeBinaryWrapper
    writableTmpDirAsHomeHook
  ];

  # Workspace packages export built `dist/` under the default condition and their
  # TypeScript sources under `_ts-source`. Upstream's release build relies on a
  # turbo remote cache to supply every dependency's `dist/`; offline we instead
  # bundle straight from source by resolving the `_ts-source` condition.
  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Use --target=bun instead of a platform-specific target (e.g.
    # bun-linux-x64-baseline) to avoid bun downloading that platform's runtime
    # from npm, which is blocked by the Nix sandbox. --target=bun uses the
    # running bun binary itself as the standalone-executable template, which is
    # already patchelfd for NixOS.
    bun build packages/cli/src/index.tsx \
      --compile \
      --target=bun \
      --minify \
      --conditions _ts-source \
      --define 'BUNDLER_INJECTED_GITLAB_LANGUAGE_SERVER_VERSION="${finalAttrs.version}"' \
      --define 'BUNDLER_INJECTED_ENVIRONMENT="production"' \
      --define 'BUNDLER_INJECTED_DISTRIBUTION="binary"' \
      --no-compile-autoload-dotenv \
      --no-compile-autoload-bunfig \
      --compile-exec-argv=--use-system-ca \
      --sourcemap=inline \
      --outfile packages/cli/bin/duo

    runHook postBuild
  '';

  # bun build --compile appends the JS bundle to the bun binary; strip would
  # discard it and break the resulting executable.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 packages/cli/bin/duo $out/bin/duo

    wrapProgram $out/bin/duo \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "node_modules"
    ];
  };

  meta = {
    changelog = "https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp/-/blob/main/CHANGELOG.md";
    description = "CLI for GitLab AI assistant";
    downloadPage = "https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp";
    homepage = "https://about.gitlab.com/gitlab-duo/";
    license = lib.licenses.mit;
    mainProgram = "duo";
    maintainers = with lib.maintainers; [ afontaine ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
