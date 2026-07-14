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
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.1.4.tar.gz";
      hash = "sha256-PYccak0VWD45nmewSGykl+QdkRHa/w2KtGiSroDK2K4=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.1.4-aarch64.tar.gz";
      hash = "sha256-XaDC8+ZztLO3ZCHJrjcNFMEj9RCRSyTYqQ0Me2uCnRo=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.1.4.dmg";
      hash = "sha256-qyFhmst3gWb4EjU2e3iavRbSSnkHVVeyNeU+tYaTEfo=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.1.4-aarch64.dmg";
      hash = "sha256-AsPZt4/ku555JnSqnDjCfA3hvZdnSTVLseeOdTYXoas=";
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
  version = "2026.1.4";
  buildNumber = "261.26222.86";
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
