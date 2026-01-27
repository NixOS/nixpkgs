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
      url = "https://download.jetbrains.com/python/dataspell-2025.3.1.tar.gz";
      hash = "sha256-N/E0Js5PXYWdfbJG8jKMy61hrfNh1Dx4TLaTKvZkTCg=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.1-aarch64.tar.gz";
      hash = "sha256-QK/TjMcEzf8r6JufDWe9vLFpnXs3sl001E0tUu9qRtM=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.1.dmg";
      hash = "sha256-OI2VbdYkNpehYsBix2sv7kCY9PNAW62wemnObffeYBc=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.1-aarch64.dmg";
      hash = "sha256-/g2O8V5uNq8OpDYb1HTyBO5cMH75Cvjsgzl2odrlpaM=";
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
  version = "2025.3.1";
  buildNumber = "253.29346.157";
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
