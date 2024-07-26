{
  stdenvNoCC,
  lib,
  fetchurl,
  testers,
  installShellFiles,
  platformsh
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "platformsh";
  version = "5.0.15";

  nativeBuildInputs = [ installShellFiles ];

  src =
    {
      x86_64-darwin = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/platform_${finalAttrs.version}_darwin_all.tar.gz";
        hash = "sha256-G5/T6ZPcvC7dvw82p2CEMEOb7GCTyCAB8xJ2lxV2UXk=";
      };
      aarch64-darwin = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/platform_${finalAttrs.version}_darwin_all.tar.gz";
        hash = "sha256-G5/T6ZPcvC7dvw82p2CEMEOb7GCTyCAB8xJ2lxV2UXk=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/platform_${finalAttrs.version}_linux_amd64.tar.gz";
        hash = "sha256-0h5Thp9pSp1TgUyNVVAjsEw+kAZVzfbsHzPMXzhZhSk=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/platform_${finalAttrs.version}_linux_arm64.tar.gz";
        hash = "sha256-m0rxC9IfqY1k4Zh027zSkDWCGNv0E0oopFfBC/vYRgU=";
      };
    }
    .${stdenvNoCC.system}
      or (throw "${finalAttrs.pname}-${finalAttrs.version}: ${stdenvNoCC.system} is unsupported.");

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    install -Dm755 platform $out/bin/platform

    installShellCompletion completion/bash/platform.bash \
        completion/zsh/_platform

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = platformsh;
    };
  };

  meta = {
    description = "Unified tool for managing your Platform.sh services from the command line";
    homepage = "https://github.com/platformsh/cli";
    license = lib.licenses.mit;
    mainProgram = "platform";
    maintainers = with lib.maintainers; [ shyim spk ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
