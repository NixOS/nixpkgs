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
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.3.tar.gz";
      hash = "sha256-lYqIFieuxES9cq66zlLB8alP1NC93YQDjJjwR2fvDg8=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.3-aarch64.tar.gz";
      hash = "sha256-lt7C16ofqf4ZtnrTZtlSyKi4ld4Qs+rfR1F49cbcsfQ=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.3.dmg";
      hash = "sha256-SnFsCGKBVyvlLVRlAc2rfCurYQLNow9laNW5xXUiYU4=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.3-aarch64.dmg";
      hash = "sha256-WWgUAW2feaX+wJbc2GPWmfE0rboWU0AEBQXINfjH/tI=";
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
  version = "2026.3";
  buildNumber = "263.7307.215";
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
