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
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.5.tar.gz";
      hash = "sha256-s9Zw7SUhmAzjhTf52nEerXNaP0l7kO/6J35xFtKf6TQ=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.5-aarch64.tar.gz";
      hash = "sha256-75OME+CICrLNkUT0tFqzUe/qAGtCGNKC6kAGeTuSK6w=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.5.dmg";
      hash = "sha256-FkTK5hu3GloxzzlAuXJUI3G5w84YvzIYtfa0h6hDZ5w=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.5-aarch64.dmg";
      hash = "sha256-lE0b8s37mBHJ7e0iHfKSW/9vpE95d/+wpjIgkcGDcr8=";
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
  version = "2025.3.5";
  buildNumber = "253.31033.21";
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
