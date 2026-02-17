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
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.4.tar.gz";
      hash = "sha256-8sR4C+a1FsngYTRnjgHKzZpmGQY2ury2Ynp3zQ3U9nk=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.4-aarch64.tar.gz";
      hash = "sha256-FRZP/2a7yBL7NdikAoc2StRLsgjI+qADtHPfkQFdwxI=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.4.dmg";
      hash = "sha256-E3i7bxnOeHP38LGY+Dw0rlpKn4ps4iyHY23L+qzCIjc=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.4-aarch64.dmg";
      hash = "sha256-OmfIeVJ69HWBdsfI9sXnWUgDIWbp9EbdOsDXdL3/taM=";
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
  version = "2025.3.4";
  buildNumber = "253.30387.92";
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
