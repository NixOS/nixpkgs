{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  libgcc,
  runCommand,
  R,
}:
let
  system = stdenv.hostPlatform.system;
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.1.tar.gz";
      sha256 = "37f13426ce4f5d859d7db246f2328ccbad61adf361d43c784cb6932af6644c28";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.1-aarch64.tar.gz";
      sha256 = "40afd38cc704cdff2be89b9f0d67bdbcb1699d7b37b25d34d44d2d52ef6a46d3";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.1.dmg";
      sha256 = "388d956dd6243697a162c062c76b2fee4098f4f3405badb07a69ce6df7de6017";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.1-aarch64.dmg";
      sha256 = "fe0d8ef15e6e36af0ea4361bd474f204ee5c307ef90af8ec833976a1dae5a5a3";
    };
  };
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "dataspell";

  wmClass = "jetbrains-dataspell";
  product = "DataSpell";

  version = "2025.3.1";
  buildNumber = "253.29346.157";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    libgcc
    (runCommand "libR" { } ''
      mkdir -p $out/lib
      ln -s ${R}/lib/R/lib/libR.so $out/lib/libR.so
    '')
  ];

  meta = {
    homepage = "https://www.jetbrains.com/dataspell/";
    description = "Data science IDE from JetBrains";
    longDescription = "DataSpell is a new IDE from JetBrains built for Data Scientists. Mainly it integrates Jupyter notebooks in the IntelliJ platform.";
    maintainers = with lib.maintainers; [ leona ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
