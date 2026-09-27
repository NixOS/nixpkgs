{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  autoPatchelfHook,
  libsecret,
  ripgrep,
  git,
  xdg-utils,
  darwin,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  stdenv = stdenvNoCC;
  manifest = lib.importJSON ./manifest.json;
  platformKey = "${stdenv.hostPlatform.node.platform}-${stdenv.hostPlatform.node.arch}";
  platformManifestEntry =
    manifest.platforms.${platformKey}
      or (throw "cline: unsupported platform ${stdenv.hostPlatform.system}");
  binaryName = "cline";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cline";
  inherit (manifest) version;

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://registry.npmjs.org/@cline/cli-${platformKey}/-/cli-${platformKey}-${finalAttrs.version}.tgz";
    inherit (platformManifestEntry) hash;
  };

  # The npm tarball unpacks into ./package
  sourceRoot = "package";

  # The compiled binary embeds the Bun runtime; stripping breaks it.
  dontStrip = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.autoSignDarwinBinariesHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [
    libsecret
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    # The binary resolves adjacent asset directories (cline-hub/webview,
    # extensions) relative to its own path (process.execPath), so keep the
    # binary and its assets together under libexec.
    mkdir -p "$out/libexec/cline"
    cp -r bin "$out/libexec/cline/bin"
    if [ -d cline-hub ]; then
      cp -r cline-hub "$out/libexec/cline/cline-hub"
    fi
    if [ -d extensions ]; then
      cp -r extensions "$out/libexec/cline/extensions"
    fi
    chmod 755 "$out/libexec/cline/bin/${binaryName}"

    makeWrapper "$out/libexec/cline/bin/${binaryName}" "$out/bin/cline" \
      --set-default CLINE_NO_AUTO_UPDATE 1 \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            ripgrep
            git
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [ xdg-utils ]
        )
      } \
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}
      ''}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Autonomous coding agent CLI capable of creating/editing files, running commands, and using the browser";
    homepage = "https://cline.bot";
    changelog = "https://github.com/cline/cline/blob/main/apps/cli/CHANGELOG.md";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ medetcan ];
    mainProgram = "cline";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
