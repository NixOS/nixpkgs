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
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3.2.tar.gz";
      hash = "sha256-6FaCc3Kqq0jjDdmSARGk4KPIU5xrUzkSINhXcY/Gs4M=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3.2-aarch64.tar.gz";
      hash = "sha256-W7OuGrk8vab0GwCTdzKZ/sWvnYQZEDNEyEQsnM3SMqU=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3.2.dmg";
      hash = "sha256-uPkK+UkAUMC+JYiGnQZmdt1DKtTqHrjpE/ghpnuGb/w=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3.2-aarch64.dmg";
      hash = "sha256-5LPKKtCOreiYIEWFbQNPITktjORGA8v+22tbZhUc+Uk=";
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
  version = "2025.3.2";
  buildNumber = "253.30387.104";
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
