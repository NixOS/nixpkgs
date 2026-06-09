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
      url = "https://download.jetbrains.com/python/pycharm-2026.1.2.tar.gz";
      hash = "sha256-kcd1vhb7CFn5sY69RW2I4THK3zN7DOn52O0YeIZWGWY=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2026.1.2-aarch64.tar.gz";
      hash = "sha256-5rTyUmevreBL5nZPa7FuodFhWcrjSQ+7T1jMFo7P/uM=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2026.1.2.dmg";
      hash = "sha256-Fej8KylKSFKVxCMrBAcUIDwb0v5B5r1RysMAvcBVgh8=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2026.1.2-aarch64.dmg";
      hash = "sha256-oau/wa9spYnn7XE07NGsINyqof3Mu9t9WQLuPAQ4TDc=";
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
  version = "2026.1.2";
  buildNumber = "261.24374.152";
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
