{
  lib,
  stdenvNoCC,
  buildPackages,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs_22,
  makeWrapper,
  versionCheckHook,
  rolldown,
  installShellFiles,
  version ? "2026.4.2",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openclaw";
  version = version;

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "openclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wVS2OuBNrF1yWjmINxde0kC5mvY2QUUtwYpYrZcARkI=";
  };

  pnpmDepsHash = "sha256-aHepSWiQ4+UyjPHBF+4+M9/nFrgfCw422q671saJM+U=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = finalAttrs.pnpmDepsHash;
  };

  buildInputs = [ rolldown ];

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10
    nodejs_22
    makeWrapper
    installShellFiles
  ];

  buildPhase = ''
    runHook preBuild

    pnpm install --frozen-lockfile

    # Replace pnpm-installed rolldown with the Nix-built version
    rm -rf node_modules/rolldown node_modules/@rolldown/pluginutils
    mkdir -p node_modules/@rolldown node_modules/.pnpm/node_modules/@rolldown
    cp -r ${rolldown}/lib/node_modules/rolldown node_modules/rolldown
    cp -r ${rolldown}/lib/node_modules/@rolldown/pluginutils node_modules/@rolldown/pluginutils
    cp -r ${rolldown}/lib/node_modules/rolldown node_modules/.pnpm/node_modules/rolldown
    cp -r ${rolldown}/lib/node_modules/@rolldown/pluginutils node_modules/.pnpm/node_modules/@rolldown/pluginutils
    chmod -R u+w node_modules/rolldown node_modules/@rolldown/pluginutils \
      node_modules/.pnpm/node_modules/rolldown node_modules/.pnpm/node_modules/@rolldown/pluginutils

    # In Nix sandbox, npm install has no network access. Patch the staging
    # script to accept version-mismatched deps from root node_modules
    # instead of falling back to npm install.
    sed -i 's/if (installedVersion === null || !dependencyVersionSatisfied(spec, installedVersion)) {/if (installedVersion === null) {/' scripts/stage-bundled-plugin-runtime-deps.mjs
    pnpm build
    pnpm ui:build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    libdir=$out/lib/openclaw
    mkdir -p $libdir $out/bin


    cp --reflink=auto -r package.json dist node_modules $libdir/
    cp --reflink=auto -r assets docs skills patches extensions $libdir/

    rm -f $libdir/node_modules/.pnpm/node_modules/clawdbot \
      $libdir/node_modules/.pnpm/node_modules/moltbot \
      $libdir/node_modules/.pnpm/node_modules/openclaw-control-ui

    # Remove broken symlinks created by pnpm workspace linking in extensions
    find $libdir/extensions -xtype l -delete

    makeWrapper ${lib.getExe nodejs_22} $out/bin/openclaw \
      --add-flags "$libdir/dist/index.js" \
      --set NODE_PATH "$libdir/node_modules"
    ln -s $out/bin/openclaw $out/bin/moltbot
    ln -s $out/bin/openclaw $out/bin/clawdbot

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenvNoCC.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd openclaw \
        --bash <(${emulator} $out/bin/openclaw completion --shell bash) \
        --fish <(${emulator} $out/bin/openclaw completion --shell fish) \
        --zsh <(${emulator} $out/bin/openclaw completion --shell zsh)
    ''
  );

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Self-hosted, open-source AI assistant/agent";
    longDescription = ''
      Self-hosted AI assistant/agent connected to all your apps on your Linux
      or macOS machine and controlled via your choice of chat app.

      Note: Project is in early/rapid development and uses LLMs to parse untrusted
      content while having full access to system by default.

      Parsing untrusted input with LLMs leaves them vulnerable to prompt injection.

      (Originally known as Moltbot and ClawdBot)
    '';
    homepage = "https://openclaw.ai";
    changelog = "https://github.com/openclaw/openclaw/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "openclaw";
    maintainers = with lib.maintainers; [
      chrisportela
      mkg20001
    ];
    platforms = with lib.platforms; linux ++ darwin;
    knownVulnerabilities = [
      "Project uses LLMs to parse untrusted content, making it vulnerable to prompt injection, while having full access to system by default."
    ];
  };
})
