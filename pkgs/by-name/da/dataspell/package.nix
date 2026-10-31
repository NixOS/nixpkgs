{
  # keep-sorted start case=no
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  libgcc,
  R,
  runCommand,
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

  pname = "dataspell";

  wmClass = "jetbrains-dataspell";
  product = "DataSpell";

  src = fetchurl (versionInfo.urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  # NOTE: This `lib.optionals` is only here because the old Darwin builder ignored `buildInputs`.
  #       DataSpell may need these, even on Darwin!
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libgcc
    (runCommand "libR" { } ''
      mkdir -p $out/lib
      ln -s ${R}/lib/R/lib/libR.so $out/lib/libR.so
    '')
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/dataspell/";
    description = "Data science IDE from JetBrains";
    longDescription = ''
      DataSpell is an IDE from JetBrains built for Data Scientists.
      Mainly it integrates Jupyter notebooks in the IntelliJ platform.
    '';
    maintainers = with lib.maintainers; [ leona ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
