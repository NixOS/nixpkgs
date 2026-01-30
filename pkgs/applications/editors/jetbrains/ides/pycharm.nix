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
      url = "https://download.jetbrains.com/python/pycharm-2025.3.2.tar.gz";
      hash = "sha256-YLXO+YhulYfkOSR6fjZKuppmPa+uLqvP/E4NxAm7o8Q=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2025.3.2-aarch64.tar.gz";
      hash = "sha256-kphcT6a7JV72FqcTq7iuvAcolSgWdFvObn/o0jZP69g=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2025.3.2.dmg";
      hash = "sha256-Lxyp1g0KYapesVJ+LkRFslzIGrp2KPMrXP9nFx/CTYI=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2025.3.2-aarch64.dmg";
      hash = "sha256-lWH6M5lOjUYwzx2AqEv53V7J+5PEF9+KMZKfqbivUeY=";
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
  version = "2025.3.2";
  buildNumber = "253.30387.127";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
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
