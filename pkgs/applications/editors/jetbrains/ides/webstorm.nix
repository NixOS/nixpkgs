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
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.1.tar.gz";
      sha256 = "08a851d216b741c49ebb6846e178fb823d329fe7b9824a2134b68c8fd25ba2ae";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.1-aarch64.tar.gz";
      sha256 = "fd8bb3ee70c549165d9102437bca03e857fc147281c1d7382249d4690c31dd87";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.1.dmg";
      sha256 = "a6cb906562f95b37e9c1e34c9bd9561dea653a726c95d02bfa957acbe909b88d";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.1-aarch64.dmg";
      sha256 = "1c21990cee2bbbffdd8f6c90e8071bc03ec7fe5a3662e51931c15222d4b7ccb2";
    };
  };
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "webstorm";

  wmClass = "jetbrains-webstorm";
  product = "WebStorm";

  version = "2025.3.1";
  buildNumber = "253.29346.143";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    musl
  ];

  meta = {
    homepage = "https://www.jetbrains.com/webstorm/";
    description = "Web IDE from JetBrains";
    longDescription = "WebStorm provides an editor for HTML, JavaScript (incl. Node.js), and CSS with on-the-fly code analysis, error prevention and automated refactorings for JavaScript code.";
    maintainers = with lib.maintainers; [
      abaldeau
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
