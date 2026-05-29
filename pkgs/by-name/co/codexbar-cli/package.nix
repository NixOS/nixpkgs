{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
  curl,
  sqlite,
}:

let
  platforms = {
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-aarch64";
    x86_64-darwin = "macos-x86_64";
    aarch64-darwin = "macos-arm64";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codexbar-cli";
  version = "0.31.0";

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "codexbar-cli: unsupported platform ${stdenvNoCC.hostPlatform.system}");

  # Tarball has no top-level directory.
  sourceRoot = ".";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  # Swift runtime is statically linked; these are the only dynamic deps.
  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    curl
    sqlite
    (lib.getLib stdenv.cc.cc) # libstdc++.so.6, libgcc_s.so.1
  ];

  installPhase = ''
    runHook preInstall

    # The binary locates VERSION relative to argv[0], so it must keep VERSION
    # alongside it and be invoked by absolute path. makeWrapper's default exec
    # sets argv[0] to the target's absolute path, satisfying both.
    install -Dm755 CodexBarCLI $out/libexec/codexbar-cli/codexbar
    install -Dm644 VERSION $out/libexec/codexbar-cli/VERSION

    makeWrapper $out/libexec/codexbar-cli/codexbar $out/bin/codexbar

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    sources = lib.mapAttrs (
      system: suffix:
      fetchurl {
        url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBarCLI-v${finalAttrs.version}-${suffix}.tar.gz";
        hash =
          {
            x86_64-linux = "sha256-caaM9r6eE9tGsOv5dkR3XX9hzotOu65cH7lBUPDHTyY=";
            aarch64-linux = "sha256-mVeN+84CD26FAD37fFJuoKWNiYQ99W8J7ZdmgldLceg=";
            x86_64-darwin = "sha256-otzbCE8upcsgCzZ3rhC5ZmMRbtcl6AM3C/ZbBtNS0NQ=";
            aarch64-darwin = "sha256-SveEqwP1k0tEHS4CPFkGqbip+ul+jfADZiFFMx6lMqA=";
          }
          .${system};
      }
    ) platforms;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Show usage stats for OpenAI Codex and Claude Code from the command line";
    homepage = "https://github.com/steipete/CodexBar";
    changelog = "https://github.com/steipete/CodexBar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "codexbar";
    maintainers = with lib.maintainers; [ qweered ];
    platforms = builtins.attrNames platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
