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

  pname = "mps";

  wmClass = "jetbrains-MPS";
  product = "MPS";

  src = fetchurl (versionInfo.urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/mps/";
    description = "IDE for building domain-specific languages from JetBrains";
    longDescription = "A metaprogramming system which uses projectional editing which allows users to overcome the limits of language parsers, and build DSL editors, such as ones with tables and diagrams.";
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
