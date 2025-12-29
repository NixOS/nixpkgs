{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,

}:
let
  system = stdenv.hostPlatform.system;
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/mps/2025.3/MPS-2025.3.tar.gz";
      sha256 = "c4023e52b4e17824d61d2768238619be14e5ae5735db533e3951647f377b6b79";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/mps/2025.3/MPS-2025.3.tar.gz";
      sha256 = "c4023e52b4e17824d61d2768238619be14e5ae5735db533e3951647f377b6b79";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/mps/2025.3/MPS-2025.3-macos.dmg";
      sha256 = "c216008ca905efd9ab9271df9599ef38ecb66cba2c61482e7a56434ae3eddee6";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/mps/2025.3/MPS-2025.3-macos-aarch64.dmg";
      sha256 = "dc79c41ce851448f4862306173914eee1e63e230410ed65356498efd2d5f0444";
    };
  };
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "mps";

  wmClass = "jetbrains-MPS";
  product = "MPS";

  version = "2025.3";
  buildNumber = "253.28294.432";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  meta = {
    homepage = "https://www.jetbrains.com/mps/";
    description = "IDE for building domain-specific languages from JetBrains";
    longDescription = "A metaprogramming system which uses projectional editing which allows users to overcome the limits of language parsers, and build DSL editors, such as ones with tables and diagrams.";
    maintainers = [ ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
