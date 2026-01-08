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
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3.tar.gz";
      hash = "sha256-kMilT2GSRaVDXDQ/lPOVlatZzTy62laeKx4ovKzby0o=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3-aarch64.tar.gz";
      hash = "sha256-IE7T9yYod9Ckaq8wxbr7cha06XNr6+5xQlyZPBhIavg=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3.dmg";
      hash = "sha256-KC/X8wLZWt7tAi+NbGedMpJ3j5YgU5SvUt0JD2IB8zg=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3-aarch64.dmg";
      hash = "sha256-sQyr2pPIjSe8wTWkSh/Zj+YP6DBWBtbnWg1bc28N8nQ=";
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
  version = "2025.3";
  buildNumber = "253.28294.342";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    libgcc
  ];

  # NOTE: meta attrs are currently used by the desktop entry, so changing them may cause rebuilds (see TODO in README)
  meta = {
    homepage = "https://www.jetbrains.com/remote-development/gateway/";
    description = "Remote development for JetBrains products";
    longDescription = "JetBrains Gateway is a lightweight launcher that connects a remote server with your local machine, downloads necessary components on the backend, and opens your project in JetBrains Client.";
    maintainers = [ ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
