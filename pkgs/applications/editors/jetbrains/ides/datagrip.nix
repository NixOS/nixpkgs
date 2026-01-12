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
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.3.tar.gz";
      hash = "sha256-cV0shZxezpvllsM4aUJPLw+PzvSxqy44F5WE10VA764=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.3-aarch64.tar.gz";
      hash = "sha256-MWqkJiZ7ElSPLv0BT1dcszFbbZOr2Ub7gRrN2bUG1BY=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.3.dmg";
      hash = "sha256-JQfAVG4N2UFlQtyWF2GjHzozwOPGi6elInOSQyBf7js=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.3-aarch64.dmg";
      hash = "sha256-QwPJLy4Hv0FJErVTUDirG1iDn8noMlnyk4Zmk0uqZnQ=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "datagrip";

  wmClass = "jetbrains-datagrip";
  product = "DataGrip";

  # update-script-start: version
  version = "2025.3.3";
  buildNumber = "253.29346.270";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/datagrip/";
    description = "Database IDE from JetBrains";
    longDescription = ''
      DataGrip is an IDE from JetBrains built for database admins.
      It allows you to quickly migrate and refactor relational databases, construct efficient, statically checked SQL queries and much more.
    '';
    maintainers = [ ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
