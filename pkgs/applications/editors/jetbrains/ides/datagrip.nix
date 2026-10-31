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
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.6.1.tar.gz";
      hash = "sha256-ASewtG6ai9L2UTCzlosM0E/zDYOfkfKzgJ5kk025ieo=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.6.1-aarch64.tar.gz";
      hash = "sha256-9ZPBU2AtHZZDo291lH8K0N5W8vqEN9W93RnszeLBRo8=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.6.1.dmg";
      hash = "sha256-4ZeSPYwv46/zCqb57Ei+2kk5fg8MHvBc+DQiEFUKdHc=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.2.6.1-aarch64.dmg";
      hash = "sha256-6lX9Z0uHyYPrpFoRUnSmI/D7f+Nlah3Z/tQJ1fhtHZ0=";
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
  version = "2026.2.6.1";
  buildNumber = "262.11879.103";
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
