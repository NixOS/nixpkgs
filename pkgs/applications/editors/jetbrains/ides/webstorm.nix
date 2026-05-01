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
      url = "https://download.jetbrains.com/webstorm/WebStorm-2026.1.1.tar.gz";
      hash = "sha256-r9XetjreFB6qU7VQbHsFLn7boKhZylfyGsfPNumFQZw=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2026.1.1-aarch64.tar.gz";
      hash = "sha256-Damq3svwCOrE+fTBBVY8vi/1vtFJFFqFsSWQhY9L/x4=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2026.1.1.dmg";
      hash = "sha256-+s6MjE4zD4YZxnYRqsaXVthTWNnCn1HS3K7Ik+lb2cI=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2026.1.1-aarch64.dmg";
      hash = "sha256-/WwGXnvYZz8MzOOQgf4BGMRP7cLIv8FA1lK8NvIgtoo=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "webstorm";

  wmClass = "jetbrains-webstorm";
  product = "WebStorm";

  # update-script-start: version
  version = "2026.1.1";
  buildNumber = "261.23567.141";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    musl
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
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
