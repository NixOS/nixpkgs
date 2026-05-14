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
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2026.1.1.tar.gz";
      hash = "sha256-hXQIvnyjosH3uEUpi43NJYnk8cMXVVlKblpiGeVlekk=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2026.1.1-aarch64.tar.gz";
      hash = "sha256-nsF/Oo0p+hXqSehIhrPc7i0zURDXgtf/rBpMFKgq+7c=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2026.1.1.dmg";
      hash = "sha256-1pqtAR8r2ZwU/RhFMDsyFBhhRYvsPrT5F/n3kSP2viA=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2026.1.1-aarch64.dmg";
      hash = "sha256-orFAOXR9A/0S7lhwkD9bAXyp24HaDSlXe/rL4iT6+80=";
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
  version = "2026.1.1";
  buildNumber = "261.23567.152";
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
