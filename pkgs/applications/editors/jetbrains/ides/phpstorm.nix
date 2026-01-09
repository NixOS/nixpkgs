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
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1.1.tar.gz";
      hash = "sha256-u5b/elgB4/kMrgkgyqhz4L2BZqsNqt6Fwb+JIC1eSEk=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1.1-aarch64.tar.gz";
      hash = "sha256-iHIsnxTpuunA/L8/ZQsbQCqEfIu2lvtNNq9V0yPvBvY=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1.1.dmg";
      hash = "sha256-L4brbVVJgRgv/A2yu3oDGycWX6z5IiDf/7Zd/W2V2tk=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1.1-aarch64.dmg";
      hash = "sha256-I1j18NK10Vda4F2VOIm3mvjqUvhFMc7OYq1NpyRG+bw=";
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
  version = "2025.3.1.1";
  buildNumber = "253.29346.257";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
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
