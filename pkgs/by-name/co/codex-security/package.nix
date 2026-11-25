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
  version = "0.11.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex-security";
    tag = "npm-v${finalAttrs.version}";
    hash = "sha256-n7nMZpep7XyMw3ZycDWR2P60efJUe5Nffvl5lXR2Yxo=";
  };

  npmPackage = fetchurl {
    url = "https://registry.npmjs.org/@openai/codex-security/-/codex-security-${finalAttrs.version}.tgz";
    hash = "sha512-XxnhiX7fREcw3cbsTOoVVXnctSTeB5eF4ql6TPYVheoIxSPxjkkVO+JQNjeGS3AWWC6h+Lwq0RSRJW0tF9yCKA==";
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
    hash = "sha256-lHsFNQjdoR7q97vXjXC02cKRdjRVspkkfSdjzrw2Yxk=";
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

    # The build script generates files under plugins/, outside the source root.
    chmod --recursive u+w ../../plugins

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Reinstall with only the production dependencies to keep the closure small.
    rm -rf node_modules
    pnpm install --force --offline --prod --ignore-scripts --frozen-lockfile

    mkdir -p "$out/lib/codex-security"
    cp -r bin dist schemas node_modules package.json LICENSE README.md \
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
