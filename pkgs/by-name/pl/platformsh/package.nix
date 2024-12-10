{
  stdenvNoCC,
  lib,
  fetchurl,
  testers,
  installShellFiles,
  platformsh,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "platformsh";
  version = "5.0.13";

  nativeBuildInputs = [ installShellFiles ];

  src =
    {
      x86_64-darwin = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/platform_${finalAttrs.version}_darwin_all.tar.gz";
        hash = "sha256-dCo5+de+9hXxrv+uPn0UoAh4UfSv+PyR2z/ytpfby0g=";
      };
      aarch64-darwin = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/platform_${finalAttrs.version}_darwin_all.tar.gz";
        hash = "sha256-dCo5+de+9hXxrv+uPn0UoAh4UfSv+PyR2z/ytpfby0g=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/platform_${finalAttrs.version}_linux_amd64.tar.gz";
        hash = "sha256-JP0RCqNQ8V4sFP3645MW+Pd9QfPFRAuTbVPIK6WD6PQ=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/platform_${finalAttrs.version}_linux_arm64.tar.gz";
        hash = "sha256-vpk093kpGAmMevd4SVr3KSIjUXUqt3yWDZFHOVxu9rw=";
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
    description = "The unified tool for managing your Platform.sh services from the command line";
    homepage = "https://github.com/platformsh/cli";
    license = lib.licenses.mit;
    mainProgram = "platform";
    maintainers = with lib.maintainers; [
      shyim
      spk
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
