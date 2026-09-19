{
  lib,
  stdenvNoCC,
  fetchurl,
  versionCheckHook,
}:

let
  platforms = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    aarch64-darwin = "darwin_arm64";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "inngest";
  version = "1.44.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system};
  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 inngest $out/bin/inngest

    runHook postInstall
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    sources = lib.mapAttrs (
      system: platform:
      fetchurl {
        url = "https://github.com/inngest/inngest/releases/download/v${finalAttrs.version}/inngest_${finalAttrs.version}_${platform}.tar.gz";
        hash =
          {
            x86_64-linux = "sha256-vvtgP/PNefRpgM+TCdZbNe3NMj3rAAsjfpTGto2PW+I=";
            aarch64-linux = "sha256-nCi7lDjidvcN3+CRTMNKlgMS7vN8iFd7SyHGSxLdCis=";
            aarch64-darwin = "sha256-1Cbs7Y//XwUA10rUEeU0AdL5dtdSFAmzSQj3zVaN2mk=";
          }
          .${system};
      }
    ) platforms;
    updateScript = ./update.sh;
  };

  meta = {
    description = "CLI and dev server for Inngest durable workflows";
    homepage = "https://github.com/inngest/inngest";
    downloadPage = "https://github.com/inngest/inngest/releases";
    changelog = "https://github.com/inngest/inngest/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.sspl;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      albertchae
      kikos0
    ];
    mainProgram = "inngest";
    platforms = builtins.attrNames platforms;
  };
})
