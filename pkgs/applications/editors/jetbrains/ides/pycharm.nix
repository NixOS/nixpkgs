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
      url = "https://download.jetbrains.com/python/pycharm-2026.1.tar.gz";
      hash = "sha256-ZAWYX+grxqQZAFOIkwy+MYt0GbgssJyElANaK+hRGw8=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2026.1-aarch64.tar.gz";
      hash = "sha256-Hzegp0MkW6S+2Cl88dyE24Vr0XNaZMHBh/EoLtmy6Vw=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2026.1.dmg";
      hash = "sha256-jzxAjxQ9I7v5KGkFNLcjG6ZbhgLTdq0kuH22BLH9XJo=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2026.1-aarch64.dmg";
      hash = "sha256-HKQSPxtWy2rswCmfBS70nLU517h54bKZ0ayHiDu6SOs=";
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
  version = "2026.1";
  buildNumber = "261.22158.340";
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
