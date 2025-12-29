{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  pyCharmCommonOverrides,
  musl,
}:
let
  system = stdenv.hostPlatform.system;
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2025.3.1.tar.gz";
      sha256 = "933fd42d7cc2a76ad4ba23f9112294e4df013fa4c3362435a1e3368051c07391";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2025.3.1-aarch64.tar.gz";
      sha256 = "2b6f5a430132773ea7caf3046f7763ea7a031dbfab6e1be72bdc86f3cc7a758b";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2025.3.1.dmg";
      sha256 = "586c9eed67da609fc1e565a8bfc36eb155b23e5483d5dc6e9dcf8b5540f47fa5";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2025.3.1-aarch64.dmg";
      sha256 = "ec8e97856f00da902020c72b0f079cc10983de6bb4438292ea5faa1e5b0cb935";
    };
  };
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "pycharm";

  wmClass = "jetbrains-pycharm";
  product = "PyCharm";
  productShort = "PyCharm";

  version = "2025.3.1";
  buildNumber = "253.29346.142";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    musl
  ];

  meta = {
    homepage = "https://www.jetbrains.com/pycharm/";
    description = "Python IDE from JetBrains";
    longDescription = "Python IDE with complete set of tools for productive development with Python programming language. In addition, the IDE provides high-class capabilities for professional Web development with Django framework and Google App Engine. It has powerful coding assistance, navigation, a lot of refactoring features, tight integration with various Version Control Systems, Unit testing, powerful all-singing all-dancing Debugger and entire customization. PyCharm is developer driven IDE. It was developed with the aim of providing you almost everything you need for your comfortable and productive development!";
    maintainers = with lib.maintainers; [
      genericnerdyusername
      tymscar
    ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}).overrideAttrs
  pyCharmCommonOverrides
