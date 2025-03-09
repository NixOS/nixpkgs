{
  lib,
  vscode-utils,
  httpyac,
}:

let
  version = "6.16.6";
in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-httpyac";
    publisher = "anweber";
    inherit version;
    hash = "sha256-GR1DX6td/a75STpfIU0UtOxpNBWCkyzecEZdDMZTy1M=";
  };

  buildInputs = [ httpyac ];

  meta = {
    changelog = "https://github.com/AnWeber/vscode-httpyac/releases/tag/${version}";
    description = "Quickly and easily send REST, Soap, GraphQL, GRPC, MQTT, RabbitMQ and WebSocket requests directly within Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=anweber.vscode-httpyac";
    homepage = "https://github.com/AnWeber/vscode-httpyac/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
