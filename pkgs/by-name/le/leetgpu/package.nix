{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  versionCheckHook,
}:

let
  version = "1.2.0";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://cli.leetgpu.com/dist/${version}/leetgpu-linux-amd64";
      hash = "sha256-um+KHqE1mmx7dkKm3pecrZSnsT+vbMh95kWQAsLGxFw=";
    };

    aarch64-linux = fetchurl {
      url = "https://cli.leetgpu.com/dist/${version}/leetgpu-linux-arm64";
      hash = "sha256-3BcM0SHBugv/72iznR0q6t18B+u1f2auyUK1n1t5KBY=";
    };

    aarch64-darwin = fetchurl {
      url = "https://cli.leetgpu.com/dist/${version}/leetgpu-macos-arm64";
      hash = "sha256-B1Sdyw+6fDBKS3PsINmiNA9PnOtEpDZiodFPsx+qk1Y=";
    };
  };

  src = srcs.${stdenvNoCC.hostPlatform.system} or throwSystem;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "leetgpu";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  inherit src;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${src} $out/bin/leetgpu

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Run CUDA kernels from your terminal";
    homepage = "https://leetgpu.com/cli";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "leetgpu";
  };
})
