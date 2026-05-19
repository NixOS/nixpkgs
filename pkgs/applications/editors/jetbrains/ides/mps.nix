{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,

}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/mps/2025.3/MPS-2025.3.tar.gz";
      hash = "sha256-xAI+UrTheCTWHSdoI4YZvhTlrlc121M+OVFkfzd7a3k=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/mps/2025.3/MPS-2025.3.tar.gz";
      hash = "sha256-xAI+UrTheCTWHSdoI4YZvhTlrlc121M+OVFkfzd7a3k=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/mps/2025.3/MPS-2025.3-macos.dmg";
      hash = "sha256-whYAjKkF79mrknHflZnvOOy2bLosYUguelZDSuPt3uY=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/mps/2025.3/MPS-2025.3-macos-aarch64.dmg";
      hash = "sha256-3HnEHOhRRI9IYjBhc5FO7h5j4jBBDtZTVkmO/S1fBEQ=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "mps";

  wmClass = "jetbrains-MPS";
  product = "MPS";

  # update-script-start: version
  version = "2025.3";
  buildNumber = "253.28294.432";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/mps/";
    description = "IDE for building domain-specific languages from JetBrains";
    longDescription = "A metaprogramming system which uses projectional editing which allows users to overcome the limits of language parsers, and build DSL editors, such as ones with tables and diagrams.";
    maintainers = [ ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
