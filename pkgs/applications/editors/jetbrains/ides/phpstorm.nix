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
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.3.tar.gz";
      hash = "sha256-CX7LgeWLKAFYcDHubXqQt9Shz5EVscly/dMwHmz6ht4=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.3-aarch64.tar.gz";
      hash = "sha256-s79ZVBy1z57uURH8EGFb+ZCC01v8ChSGoal/JNricEU=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.3.dmg";
      hash = "sha256-PgHuc13fVOBcfK5yPK4Fr0pWlYQd2gmWTYjCKjI1ebE=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.3-aarch64.dmg";
      hash = "sha256-vIbOdh2s6Fx44ZWBlL+O1CKotMVWYRkOKqV2FNaEZ+0=";
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
  version = "2025.3.3";
  buildNumber = "253.31033.138";
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
