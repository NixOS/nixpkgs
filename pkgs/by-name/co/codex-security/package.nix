{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
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

let
  nativePluginTarget =
    {
      aarch64-darwin = "darwin-arm64";
      aarch64-linux = "linux-arm64-gnu";
      x86_64-darwin = "darwin-x64";
      x86_64-linux = "linux-x64-gnu";
    }
    .${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "codex-security";
  version = "0.1.31";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex-security";
    tag = "npm-v${finalAttrs.version}";
    hash = "sha256-TA0dxV9VYvvmPU2ZqI5i0XGHaIzNYhqlkLPztZMbtCQ=";
  };

  npmPackage = fetchurl {
    url = "https://registry.npmjs.org/@openai/codex-security/-/codex-security-${finalAttrs.version}.tgz";
    hash = "sha512-XdxIQ+JQH3iysFPW2VdFcKAJJo+M+G4hR9x/KlVimMcbmocDVtQT+trjjfNPqZUdb2ZHrW7HHGepeRhMbMvCHQ==";
  };

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
    hash = "sha256-7gu3a76l+5XgIbpjr2NFt5Wcp/+LRjUNAaxZ0cW8T8c=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_11
    pnpmConfigHook
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    ncurses
  ];

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
    cp -r bin dist node_modules package.json LICENSE README.md \
      "$out/lib/codex-security/"

    # The plugin bundle is generated during npm prepack and is not in the source tag.
    tar --extract --gzip --file=${finalAttrs.npmPackage} \
      --directory="$out/lib/codex-security" --strip-components=1 \
      package/_bundled_plugin

    find "$out/lib/codex-security/_bundled_plugin/mcp/native" \
      -mindepth 1 -maxdepth 1 -type d \
      ! -name licenses ! -name ${lib.escapeShellArg nativePluginTarget} \
      -exec rm --recursive --force {} +

    find "$out/lib/codex-security/node_modules" -name "*.android*" -delete

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
    changelog = "https://github.com/openai/codex-security/releases/tag/${finalAttrs.src.tag}";
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
