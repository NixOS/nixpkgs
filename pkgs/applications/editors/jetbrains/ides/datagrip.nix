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
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.1.tar.gz";
      hash = "sha256-iO08H4cMYVKx2p1iJsKqooC5YNGIjTbdqwnM98JC2W8=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.1-aarch64.tar.gz";
      hash = "sha256-8omllZC5WbYOsXsZ6JTVaDNh/QIyUVgmw3zBwY2nfkY=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.1.dmg";
      hash = "sha256-UBKNSUVhzJ932Ja7rrugKzqlzxiE5Ynv91yDT6onCNM=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2026.1-aarch64.dmg";
      hash = "sha256-V7ip2Er8bQL0feLvovF/rpJpCTYM/MhEywNax91F8Gk=";
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
  version = "2026.1";
  buildNumber = "261.22158.299";
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
