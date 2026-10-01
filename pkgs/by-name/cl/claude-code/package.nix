# NOTE: Use the following command to update the package
# ```sh
# nix-shell maintainers/scripts/update.nix --arg commit true --arg predicate '(path: pkg: builtins.elem path [["claude-code"] ["vscode-extensions" "anthropic" "claude-code"]])'
# ```
{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  autoPatchelfHook,
  buildPackages,
  alsa-lib,
  procps,
  ripgrep,
  bubblewrap,
  socat,
  zstd,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  manifest ? lib.importJSON ./manifest.zst.json,
}:
let
  stdenv = stdenvNoCC;
  baseUrl = "https://downloads.claude.ai/claude-code-releases";
  platformKey = "${stdenv.hostPlatform.node.platform}-${stdenv.hostPlatform.node.arch}";
  platformManifestEntry = manifest.platforms.${platformKey};
  # Drop the patch once nixpkgs' patchelf includes NixOS/patchelf#665
  patchelf = buildPackages.patchelf.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patchelf-update-dt-verdef.patch ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "claude-code";
  inherit (manifest) version;

  src = fetchurl {
    url = "${baseUrl}/${finalAttrs.version}/${platformKey}/${platformManifestEntry.binary}";
    sha256 = platformManifestEntry.checksum;
  };

  dontUnpack = true;
  dontBuild = true;
  __noChroot = stdenv.hostPlatform.isDarwin;
  # otherwise the bun runtime is executed instead of the binary
  dontStrip = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    patchelf
  ];

  # DT_RPATH, not DT_RUNPATH: only DT_RPATH also serves the dlopen'd
  # audio-capture.node, which needs libasound for voice mode
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];
  patchelfFlags = [ "--force-rpath" ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    unzstd -q $src -o $out/bin/claude
    chmod 755 $out/bin/claude

    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1 \
      --set-default FORCE_AUTOUPDATE_PLUGINS 1 \
      --set DISABLE_INSTALLATION_CHECKS 1 \
      --set USE_BUILTIN_RIPGREP 0 \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            # claude-code uses [node-tree-kill](https://github.com/pkrumins/node-tree-kill) which requires procps's pgrep(darwin) or ps(linux)
            procps
            # https://code.claude.com/docs/en/troubleshooting#search-and-discovery-issues
            ripgrep
          ]
          # the following packages are required for the sandbox to work (Linux only)
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            bubblewrap
            socat
          ]
        )
      }

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";
  postInstallCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    readelf -dW $out/bin/.claude-wrapped | grep '(RPATH).*${lib.getLib alsa-lib}/lib' >/dev/null
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://claude.com/product/claude-code";
    changelog = "https://github.com/anthropics/claude-code/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      adeci
      malo
      markus1189
      mirkolenz
      omarjatoi
      oskarwires
      xiaoxiangmoe
    ];
    mainProgram = "claude";
  };
})
