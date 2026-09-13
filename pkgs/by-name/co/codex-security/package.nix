{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_11,
  nodejs,
  pnpmConfigHook,
  makeWrapper,
  autoPatchelfHook,
  git,
  ncurses,
  python3,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codex-security";
  version = "0.1.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex-security";
    tag = "npm-v${finalAttrs.version}";
    hash = "sha256-WAU/vRpo3k2fIW1xIWoS9ZxopXoV0T80+95m2X/NUDY=";
  };

  # The npm package lives in the `sdk/typescript` subdirectory of the
  # repository, so root the whole build there.
  sourceRoot = "${finalAttrs.src.name}/sdk/typescript";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-IsqSGb/P9sF2htuHeo7M+lOiq5FdHGxm80g82nc5Diw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_11
    pnpmConfigHook
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # The prebuilt @openai/codex binary is a dynamically linked native
  # executable that autoPatchelfHook needs to fix up on Linux. The bundled
  # zsh in the codex resources links libtinfo.so.6, which ncurses provides.
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    ncurses
  ];

  # The @napi-rs/canvas dependency ships prebuilt binaries for every
  # platform, including an Android arm64 build that links liblog.so from
  # the Android NDK. Android arm64 is AArch64, so on aarch64-linux this
  # binary matches the build target and autoPatchelfHook tries to patch it,
  # unlike on x86_64-linux where it is skipped for an architecture
  # mismatch. The binary is never used on any Linux host, so ignore its
  # otherwise unsatisfiable dependency.
  autoPatchelfIgnoreMissingDeps = [ "liblog.so" ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Reinstall with only the production dependencies to keep the closure small.
    rm -rf node_modules
    pnpm install --force --offline --prod --ignore-scripts --frozen-lockfile

    mkdir -p "$out/lib/codex-security"
    cp -r bin dist _bundled_plugin node_modules package.json LICENSE README.md \
      "$out/lib/codex-security/"

    makeWrapper "${lib.getExe nodejs}" "$out/bin/codex-security" \
      --add-flags "$out/lib/codex-security/bin/codex-security.mjs" \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          python3
        ]
      }"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "npm-v(.*)"
    ];
  };

  meta = {
    description = "CLI and TypeScript SDK for finding, validating, and fixing security vulnerabilities in your code";
    homepage = "https://github.com/openai/codex-security";
    changelog = "https://github.com/openai/codex-security/releases/tag/npm-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sheeeng ];
    mainProgram = "codex-security";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
