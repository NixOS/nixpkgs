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
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.2.tar.gz";
      hash = "sha256-y27WR10h640wdUExvSQAPBFAlr+oT/zPM03BHPisYMw=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.2-aarch64.tar.gz";
      hash = "sha256-Gm/rOqJV2s4zLMGLhoWTGBtupiw9nw02+QAyygUX0Gg=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.2.dmg";
      hash = "sha256-A4OgpPL95YO2LqfTQuVxiw+jBvyDSVQcdb7FroQftPw=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/datagrip/datagrip-2025.3.2-aarch64.dmg";
      hash = "sha256-pyJFSNydo4Y3J7DBHO+dYT/ZUdFrqgFsoUB8VqnsaWQ=";
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
  version = "2025.3.2";
  buildNumber = "253.29346.170";
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
