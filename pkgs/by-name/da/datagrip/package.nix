{
  # keep-sorted start
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  stdenv,
  # keep-sorted end
}:
let
  inherit (stdenv.hostPlatform) system;
  versionInfo = lib.importJSON ./version.json;
in
jetbrains.mkJetBrainsProduct {
  inherit jetbrains-libdbm fsnotifier;
  inherit (versionInfo) version buildNumber;

  pname = "datagrip";

  wmClass = "jetbrains-datagrip";
  product = "DataGrip";

  src = fetchurl (versionInfo.urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/datagrip/";
    description = "Database IDE from JetBrains";
    longDescription = ''
      DataGrip is an IDE from JetBrains built for database admins.
      It allows you to quickly migrate and refactor relational databases, construct efficient, statically checked SQL queries and much more.
    '';
    maintainers = [ ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
