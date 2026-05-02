{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  musl,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.1.tar.gz";
      hash = "sha256-TOSiFAphV/JYrUg9tB/BAtAGjn6P0DpaYHO2W3FcCGQ=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.1-aarch64.tar.gz";
      hash = "sha256-fWguwgUQstCytAMKam4scziEeyOxVEhIxS1O81HO/yI=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.1.dmg";
      hash = "sha256-W28NwTNZe3Vj19J32nY8Jrn2rFVVd+0H2NWzDCTG8nw=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.1-aarch64.dmg";
      hash = "sha256-tm/UFH/5FX0HQ/FnjQ/Jwwaf/cpIYb4j0NvKlazBp08=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "phpstorm";

  wmClass = "jetbrains-phpstorm";
  product = "PhpStorm";

  # update-script-start: version
  version = "2026.1.1";
  buildNumber = "261.23567.149";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    musl
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/phpstorm/";
    description = "PHP IDE from JetBrains";
    longDescription = "PhpStorm provides an editor for PHP, HTML and JavaScript with on-the-fly code analysis, error prevention and automated refactorings for PHP and JavaScript code.";
    maintainers = with lib.maintainers; [ tymscar ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
