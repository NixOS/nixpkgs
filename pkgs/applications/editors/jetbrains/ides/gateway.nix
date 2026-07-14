{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  libgcc,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2026.1.3.tar.gz";
      hash = "sha256-HizogKH6goX1NdcI/Fj4YsCRzDWfFvQGYSaMM9wVDCA=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2026.1.3-aarch64.tar.gz";
      hash = "sha256-CSe04BBo4jS1cIhu4NfZqaSHMaNue2eFUPa+1gOxuoo=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2026.1.3.dmg";
      hash = "sha256-WKwIP19y5EKO98JgEm468ofaRp/JO5z8lqNhtpsH4tY=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2026.1.3-aarch64.dmg";
      hash = "sha256-AHY/lY0ARkW0VoSgy0t7LLNXA965PLooWBSWxBKBV5M=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "gateway";

  wmClass = "jetbrains-gateway";
  product = "JetBrains Gateway";
  productShort = "Gateway";

  # update-script-start: version
  version = "2026.1.3";
  buildNumber = "261.25134.98";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    libgcc
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/remote-development/gateway/";
    description = "Remote development for JetBrains products";
    longDescription = "JetBrains Gateway is a lightweight launcher that connects a remote server with your local machine and opens your project in JetBrains Client.";
    maintainers = [ ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
