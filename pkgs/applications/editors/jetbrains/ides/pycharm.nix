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
      url = "https://download.jetbrains.com/python/pycharm-2026.2.0.1.tar.gz";
      hash = "sha256-SjfLLRVwNVPGHoFNjgFL+kcwhQhHDeX5aMTpZFt3FnU=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2026.2.0.1-aarch64.tar.gz";
      hash = "sha256-8ptqeCpY+rsjJxXbj++XZb/a68brWQ7UYsT5ZWIidCc=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2026.2.0.1-aarch64.dmg";
      hash = "sha256-X3YP6mtKkBvBp2UoQWfwX5AjenwwwKTSmP9GUESVDdQ=";
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
  version = "2026.2.0.1";
  buildNumber = "262.8665.369";
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
