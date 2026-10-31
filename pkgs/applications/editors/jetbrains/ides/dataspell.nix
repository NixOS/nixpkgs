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
      url = "https://download.jetbrains.com/python/dataspell-2026.1.3.1.tar.gz";
      hash = "sha256-2YfeqW/fHD+SsZSZnBxqitRVq4oEovBr1GGKr3yyq6s=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.3.1-aarch64.tar.gz";
      hash = "sha256-OKnwjskJn794zmwT8BDgn1CI1dhhh2OKSVCLL9I7FCs=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.3.1.dmg";
      hash = "sha256-jQg5bWFV0wc9j5RfI0MpThyzfrdcYb9C1x+lX6JUsSQ=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.3.1-aarch64.dmg";
      hash = "sha256-qQ9gqK2I43xErsDMdwmU3FJxuaRnaWsp36HsMeQV/Zk=";
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
  version = "2026.1.3.1";
  buildNumber = "261.27258.145";
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
