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
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.2.tar.gz";
      hash = "sha256-qkDuuP8QU+Ptcafw12LFD2n4s6tClg40uHVqZx2+hII=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.2-aarch64.tar.gz";
      hash = "sha256-k8FX/hn+U8XppVopB/ArvupH4CH+5cJlbBtjSaIarLA=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.2.dmg";
      hash = "sha256-GsOQE3NLqIifQ9mXWRT0M7hJeN+fdzSqn7pwjWf8Vcw=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2025.3.2-aarch64.dmg";
      hash = "sha256-Pc3+hlKpCIOgJLxWMOn0Uw+7cIzLD4iayaNsWYoB4mo=";
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
  version = "2025.3.2";
  buildNumber = "253.30387.83";
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
