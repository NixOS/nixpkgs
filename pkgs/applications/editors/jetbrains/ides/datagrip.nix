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
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.2.tar.gz";
      hash = "sha256-RyzXihbj7vmROdfByTmwkljqSHxdFcd+aa2GAA+Rrjs=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.2-aarch64.tar.gz";
      hash = "sha256-wVkVg0SeB0cf5ad2mt5nsPPg98tbMbCXQPEoFWQdK6U=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.2-aarch64.dmg";
      hash = "sha256-EdZcvRD7rU7hfR4tYZrmUCC/tLfdC1eX+UZ/5wFwqqE=";
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
  version = "2026.2.2";
  buildNumber = "262.9437.70";
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
