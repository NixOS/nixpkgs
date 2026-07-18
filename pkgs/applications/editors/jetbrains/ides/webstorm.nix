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
      url = "https://download.jetbrains.com/webstorm/WebStorm-2026.1.4.tar.gz";
      hash = "sha256-BPuMTwZ3Xkk4SBRCdgZ8vCoEYjhTa3d8CFOqrGlcGg0=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2026.1.4-aarch64.tar.gz";
      hash = "sha256-f9KenMq1gtldzpBraSBwOb/186WQwh1ps5Ypj5JoOU0=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2026.1.4-aarch64.dmg";
      hash = "sha256-ZYen6Ew0GYbBAmuGCDACPBsygxZ6sT787o6gqF9DJzw=";
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
  version = "2026.1.4";
  buildNumber = "261.26222.58";
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
