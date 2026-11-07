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
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2026.3.tar.gz";
      hash = "sha256-cNRI7hqipgI0phNbfvmvZAP7aRwmRGET1YfM7gb2uBM=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2026.3-aarch64.tar.gz";
      hash = "sha256-ETt3MXmQW9VBOkN82h5InPsnlO3+kkU4H9LfZfp2ohM=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2026.3.dmg";
      hash = "sha256-KzDhytw5HE55Yg7H0tSI7QvXnQBFokapolY1pL9GMLU=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2026.3-aarch64.dmg";
      hash = "sha256-akuieJnY/2RivsDoSqglGBDRUSFWQ+82gGzUf5yJ3zI=";
    };
  };
  # update-script-end: urls
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "pycharm";

  wmClass = "jetbrains-pycharm";
  product = "PyCharm";

  # update-script-start: version
  version = "2026.3";
  buildNumber = "263.7307.206";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    musl
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/pycharm/";
    description = "Python IDE from JetBrains";
    longDescription = ''
      Python IDE with complete set of tools for productive development with Python programming language.
      In addition, the IDE provides high-class capabilities for professional Web development with Django framework and Google App Engine.
      It has powerful coding assistance, navigation, a lot of refactoring features, tight integration with various Version Control Systems, Unit testing and powerful Debugger.
    '';
    maintainers = with lib.maintainers; [
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
