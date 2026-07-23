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
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.4.tar.gz";
      hash = "sha256-SF25D7dDn7b6AzcXEDLKwhpjTnCqYz1fEmvND5dl8Is=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.4-aarch64.tar.gz";
      hash = "sha256-T9q3/nxv/AA6y7CHWtOhUibR7bnKN8OZmfN3NWYTsIQ=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.4.dmg";
      hash = "sha256-W7EwYu7S3hs1564tXq8H1Uok/Gwx/8QJO4brUGOfFY4=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.4-aarch64.dmg";
      hash = "sha256-XGcfEWHHeLugvkT/WlQDsVRN33F46b1PCNhINQitqSY=";
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
  version = "2026.1.4";
  buildNumber = "261.26222.71";
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
