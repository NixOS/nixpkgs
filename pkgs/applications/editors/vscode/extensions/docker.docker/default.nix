{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-jfjd2V7IJ4GQlz/pXmrY/LlBjQ2qtlsQV4ZRD8RiWTg=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-aOFoTLVaaMFsdGoWV0OC31/nmOHXUhr2Y8K4SWcNil8=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-ugluaghNNZ/VrQORVIhc0Fuv3rHo++LO3Uwg2ujmsQc=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-6NhhAhE+r3m5tY1eR8ibKeMivmCqPooAt2rkWjWkv2w=";
      arch = "darwin-arm64";
    };
  };

  base =
    supported.${stdenv.hostPlatform.system}
      or (throw "unsupported platform ${stdenv.hostPlatform.system}");

in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = base // {
    publisher = "docker";
    name = "docker";
    version = "0.18.0";
  };

  meta = {
    description = "Official Docker DX (Developer Experience) extension. Edit smarter, ship faster with an enhanced Docker-development experience.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=docker.docker";
    homepage = "https://github.com/docker/vscode-extension#readme";
    changelog = "https://marketplace.visualstudio.com/items/docker.docker/changelog";
    license = lib.licenses.asl20;
    platforms = builtins.attrNames supported;
    maintainers = [ lib.maintainers.kozm9000 ];
  };
}
