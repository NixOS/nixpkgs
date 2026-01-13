# TODO: This IDE is deprecated and scheduled for removal in 26.05
{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  pyCharmCommonOverrides,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-community-2025.2.5.tar.gz";
      sha256 = "7f49a014f53f0f6f7c46f6710b131f390302287f4046b606331d88081cdb551f";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-community-2025.2.5-aarch64.tar.gz";
      sha256 = "67b61a3e788b043d93b3cc3e0dd3cea350e6d170402fd94adaf792cfc57e5462";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-community-2025.2.5.dmg";
      sha256 = "08ba97a278031ff1942ddefb18d8acf7582f0bb4a28ccdf5d65721bfb80ca456";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-community-2025.2.5-aarch64.dmg";
      sha256 = "040a4ed6bb7563972d844c450f615d0d11385e524fbbfdbfc9fc68d78811e994";
    };
  };
  # update-script-end: urls
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "pycharm-community";

  wmClass = "jetbrains-pycharm-ce";
  product = "PyCharm CE";
  productShort = "PyCharm";

  # update-script-start: version
  version = "2025.2.5";
  buildNumber = "252.28238.29";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # NOTE: meta attrs are currently used by the desktop entry, so changing them may cause rebuilds (see TODO in README)
  meta = {
    homepage = "https://www.jetbrains.com/pycharm/";
    description = "Free Python IDE from JetBrains (built from source)";
    longDescription = "Python IDE with complete set of tools for productive development with Python programming language. In addition, the IDE provides high-class capabilities for professional Web development with Django framework and Google App Engine. It has powerful coding assistance, navigation, a lot of refactoring features, tight integration with various Version Control Systems, Unit testing, powerful all-singing all-dancing Debugger and entire customization. PyCharm is developer driven IDE. It was developed with the aim of providing you almost everything you need for your comfortable and productive development!";
    maintainers = with lib.maintainers; [
      tymscar
    ];
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}).overrideAttrs
  pyCharmCommonOverrides
