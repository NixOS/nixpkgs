{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  versionCheckHook,
}:

let
  sources = {
    "x86_64-linux" = {
      suffix = "linux_amd64";
      hash = "sha256-3TTVSCZcsUVfNzC9hWn0OLytMAOxL39f5IlqCReCw7g=";
    };
    "aarch64-linux" = {
      suffix = "linux_arm64";
      hash = "sha256-pHygFgvMdyh8NQeGwZ1iNkaU1q+pcxvn5/CaoO/amIc=";
    };
  };
  inherit (stdenvNoCC.hostPlatform) system;
  source = sources.${system} or (throw "pipekit: no prebuilt binary for ${system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pipekit";
  version = "6.65.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/pipekit/cli/releases/download/v${finalAttrs.version}/cli_${finalAttrs.version}_${source.suffix}.tar.gz";
    inherit (source) hash;
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 pipekit -t $out/bin
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for Pipekit. Observability, governance, and scale for Argo Workflows";
    homepage = "https://pipekit.io";
    changelog = "https://github.com/pipekit/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    mainProgram = "pipekit";
    maintainers = with lib.maintainers; [ jpz13 ];
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
