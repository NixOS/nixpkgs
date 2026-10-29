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
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.1.tar.gz";
      hash = "sha256-t3ZYBjpQR11jRTJX5LQx4q6j+Nro6wEi4y0DXsY5ZkU=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.1-aarch64.tar.gz";
      hash = "sha256-m3XfF56WjiWyJjWg0wN0mCJ3oeBfZvy01V566xGUm3U=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.1.3.dmg";
      hash = "sha256-vW2LEonl0D9S0VxbeJX4jRrwhELGBwlOXwiHslvh06E=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.1-aarch64.dmg";
      hash = "sha256-1sMqgNPSAGTE3qjT3Dbp5MKJ6mCif1LHjyjnk4ixDUY=";
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
  version = "2026.2.1";
  buildNumber = "262.8665.339";
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
