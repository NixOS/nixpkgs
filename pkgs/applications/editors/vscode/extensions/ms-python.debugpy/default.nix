{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-0Je6GvtL4ZrKML2KtGCIIauwOdbVHd/aw/PT4W8vCnQ=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-Xj0pqqE9RJ9UlBkePO4z4Rr43s0mLDnK8VDm0AQhSoM=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-WWn5UIEhP587tbF9zSGit3fzM9HJQ/G3y4MdyxrjPe8=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-nKIA7h/1aLPV2jBUMm6Ni6tvjOKvdvFKnBgjX7BxjPo=";
      arch = "darwin-arm64";
    };
  };

  base =
    supported.${stdenv.hostPlatform.system}
      or (throw "unsupported platform ${stdenv.hostPlatform.system}");

in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = base // {
    name = "debugpy";
    publisher = "ms-python";
    version = "2025.10.0";
  };

  meta = {
    description = "Python debugger (debugpy) extension for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.debugpy";
    homepage = "https://github.com/Microsoft/vscode-python-debugger";
    license = lib.licenses.mit;
    platforms = builtins.attrNames supported;
    maintainers = [ lib.maintainers.carlthome ];
  };
}
