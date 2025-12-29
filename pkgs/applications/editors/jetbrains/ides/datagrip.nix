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
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.2.tar.gz";
      sha256 = "cb6ed6475d21eb8d30754131bd24003c114096bfa84ffccf334dc11cf8ac60cc";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.2-aarch64.tar.gz";
      sha256 = "1a6feb3aa255dace332cc18b868593181b6ea62c3d9f0d36f90032ca0517d068";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.2.dmg";
      sha256 = "0383a0a4f2fde583b62ea7d342e5718b0fa306fc8349541c75bec5ae841fb4fc";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.2-aarch64.dmg";
      sha256 = "a7224548dc9da3863727b0c11cef9d613fd951d16baa016ca1407c56a9ec6964";
    };
  };
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "datagrip";

  wmClass = "jetbrains-datagrip";
  product = "DataGrip";

  version = "2025.3.2";
  buildNumber = "253.29346.170";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  meta = {
    homepage = "https://www.jetbrains.com/datagrip/";
    description = "Database IDE from JetBrains";
    longDescription = "DataGrip is a new IDE from JetBrains built for database admins. It allows you to quickly migrate and refactor relational databases, construct efficient, statically checked SQL queries and much more.";
    maintainers = [ ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
