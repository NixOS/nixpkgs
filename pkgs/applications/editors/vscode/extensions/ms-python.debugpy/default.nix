{
  lib,
  stdenv,
  vscode-utils,
}:
let
  sources = {
    "x86_64-linux" = {
      arch = "linux-x64";
      hash = "sha256-OuQX94vOF5krng77oWCkOoWotpW9OH4VDU3yTjZsewE=";
    };

    "aarch64-linux" = {
      arch = "linux-arm64";
      hash = "sha256-KUKuG0yENmmV0mIGQrcDxbOvUhLaSpczqYJp4111IwA=";
    };

    "aarch64-darwin" = {
      arch = "darwin-arm64";
      hash = "sha256-mmvbMMfwtgLXgZoIn+4wQ4IVbuo8gwFTplGcHkh3PuA=";
    };
  };

  base = sources.${stdenv.hostPlatform.system}
    or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
in vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = base // {
    name = "debugpy";
    publisher = "ms-python";
    version = "2026.6.0";
  };

  meta = {
    description = "Python debugger (debugpy) extension for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.debugpy";
    homepage = "https://github.com/Microsoft/vscode-python-debugger";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.carlthome ];
  };
}
