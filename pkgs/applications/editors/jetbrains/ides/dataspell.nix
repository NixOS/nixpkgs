{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  libgcc,
  runCommand,
  R,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.1.tar.gz";
      hash = "sha256-1z7faSO2Ugb/cN/IhUvOaT9nFyji2L733Y6vKpwRmOg=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.1-aarch64.tar.gz";
      hash = "sha256-T7InWF6K1/2+GL10z6qxx+jn+N/inDnCdcyNdrOu09s=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.1.dmg";
      hash = "sha256-IHBiieH2LxB85RC3hGiqhlOKyirXrbbqSnJcdPzIMvA=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.1-aarch64.dmg";
      hash = "sha256-QZhtClvXnm8sttPnYxS/tvjn5jMScId9yMup3pD3Px8=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "dataspell";

  wmClass = "jetbrains-dataspell";
  product = "DataSpell";

  # update-script-start: version
  version = "2026.1.1";
  buildNumber = "261.23567.176";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

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
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
