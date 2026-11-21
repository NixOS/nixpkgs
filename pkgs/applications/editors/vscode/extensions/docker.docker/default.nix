{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-VJspJ2jj/ppm44UN1XMlFDZ792PM5IZLYhqPchpvRrc=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-8aj3ux8lT+gjVhL30dYsPStmfWgI5nJWEtew3YDgyRo=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-tzCpJYJMEG5CP7xfqYkW8pm/Xiqpt3gJ42zA6N0mch0=";
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
    version = "0.19.1";
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
