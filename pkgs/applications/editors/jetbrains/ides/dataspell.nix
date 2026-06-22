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
      url = "https://download.jetbrains.com/python/dataspell-2026.1.2.tar.gz";
      hash = "sha256-D5eONrO+5EL1cuskUU4cRYLgcbG7RCvlucnmw9t2COM=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.2-aarch64.tar.gz";
      hash = "sha256-SSmIPF0pDMolxeXL21UaHMbZdtYbChWVxTKZOsPhH+I=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.2.dmg";
      hash = "sha256-2qzwzGMYuy1qEuTprxwNa5gOPgCZq2MadSKN8FT8w8c=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.2-aarch64.dmg";
      hash = "sha256-MGWufS0nlswdqhACNQWtlXJwfPiYw8wUx7olIxPS15k=";
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
  version = "2026.1.2";
  buildNumber = "261.25134.18";
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
