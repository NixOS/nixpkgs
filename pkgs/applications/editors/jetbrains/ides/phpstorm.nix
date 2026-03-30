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
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.tar.gz";
      hash = "sha256-OpSc/Xg4nWh9XRpVN8FLaV1Gwz8kbM+S9WVk27jJ7gY=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1-aarch64.tar.gz";
      hash = "sha256-StoSzSx4fxeeB+PnZB5PCEzPJuWCa+HeY9u6hGGlUHg=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1.dmg";
      hash = "sha256-KN4OVeR7TCA+PigHemh0eIT+y3hRKAGFJlEFmRc45Xg=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.1-aarch64.dmg";
      hash = "sha256-V3TQIvaYH3+NmWIDJFyTcO7Zwdd+TPP0TSFmX5pjEhM=";
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
  version = "2026.1";
  buildNumber = "261.22158.283";
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
    maintainers = with lib.maintainers; [
      dritter
      tymscar
    ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
