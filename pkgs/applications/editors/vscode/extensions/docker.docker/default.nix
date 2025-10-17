{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-2m1hVQ497zQs2pmk+F+5thO4cz7dP4dDEPznPBqKfX0=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-U2BcDUiper4chL8rF4ZUSos7erfXaq1LNqYYsRe2GDk=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-qYdYmPZPlf++cJWLbhvqeO0uePbAJE4hL2bVYlKbk0c=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-oN3CWc/OLbeuyKfdPoh26yUQzH3d6YfpxacByWM43qk=";
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
    version = "0.17.0";
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
