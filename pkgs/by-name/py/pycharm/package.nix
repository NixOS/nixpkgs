{
  # keep-sorted start
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  musl,
  python3,
  stdenv,
  # keep-sorted end
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2026.2.3.tar.gz";
      hash = "sha256-6OT75Nq0Q5DQn2geBZoxbmksq9JLLhHOmP92yBIPoxM=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/pycharm-2026.2.3-aarch64.tar.gz";
      hash = "sha256-waxrdED02JRiQdYCIg6dua+sdfQYMcoh3FFozfNonQ4=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/pycharm-2026.2.3-aarch64.dmg";
      hash = "sha256-o4hXS1XSwywItdc7oDAsZpCBBgrCCYjbt2d+hD4s77A=";
    };
  };
  # update-script-end: urls
in
jetbrains.mkJetBrainsProduct {
  inherit jetbrains-libdbm fsnotifier;

  pname = "pycharm";

  wmClass = "jetbrains-pycharm";
  product = "PyCharm";

  # update-script-start: version
  version = "2026.2.3";
  buildNumber = "262.10968.92";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # keep-sorted start
    jetbrains.cythonDebugSpeedupsHook
    python3
    python3.pkgs.setuptools
    # keep-sorted end
  ];

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
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
