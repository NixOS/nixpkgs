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
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3.tar.gz";
      sha256 = "90c8a54f619245a5435c343f94f39595ab59cd3cbada569e2b1e28bcacdbcb4a";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3-aarch64.tar.gz";
      sha256 = "204ed3f7262877d0a46aaf30c5bafb7216b4e9736bebee71425c993c18486af8";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3.dmg";
      sha256 = "282fd7f302d95adeed022f8d6c679d3292778f96205394af52dd090f6201f338";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2025.3-aarch64.dmg";
      sha256 = "b10cabda93c88d27bcc135a44a1fd98fe60fe8305606d6e75a0d5b736f0df274";
    };
  };
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "gateway";

  wmClass = "jetbrains-gateway";
  product = "JetBrains Gateway";
  productShort = "Gateway";

  version = "2025.3";
  buildNumber = "253.28294.342";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    libgcc
  ];

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
