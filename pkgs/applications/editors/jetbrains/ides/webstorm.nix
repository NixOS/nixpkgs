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
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.1.tar.gz";
      hash = "sha256-CKhR0ha3QcSeu2hG4Xj7gj0yn+e5gkohNLaMj9Jboq4=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.1-aarch64.tar.gz";
      hash = "sha256-/Yuz7nDFSRZdkQJDe8oD6Ff8FHKBwdc4IknUaQwx3Yc=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.1.dmg";
      hash = "sha256-psuQZWL5WzfpweNMm9lWHeplOnJsldAr+pV6y+kJuI0=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.1-aarch64.dmg";
      hash = "sha256-HCGZDO4ru//dj2yQ6AcbwD7H/lo2YuUZMcFSItS3zLI=";
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
  version = "2025.3.1";
  buildNumber = "253.29346.143";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
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
