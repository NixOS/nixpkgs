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
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1.tar.gz";
      sha256 = "fd8937ab6b79605cefc9917ffe6a08e05a6b7cc0256fa2178623d24ec322fa29";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1-aarch64.tar.gz";
      sha256 = "7648667f85b4c45928b04d4c26f22882a8aa65a787a64fa2f7affe51a1bc2a61";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1.dmg";
      sha256 = "11988bcee5d94b271ea67aeacd3e836029595a6cfebfec2659565fc18a4ad2d1";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1-aarch64.dmg";
      sha256 = "0453e0a6ee86c3cbf97b8c48f2826751d8085bf8211b541a04752621c5af16bc";
    };
  };
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "phpstorm";

  wmClass = "jetbrains-phpstorm";
  product = "PhpStorm";

  version = "2025.3.1";
  buildNumber = "253.29346.151";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    musl
  ];

  meta = {
    homepage = "https://www.jetbrains.com/phpstorm/";
    description = "PHP IDE from JetBrains";
    longDescription = "PhpStorm provides an editor for PHP, HTML and JavaScript with on-the-fly code analysis, error prevention and automated refactorings for PHP and JavaScript code. ";
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
