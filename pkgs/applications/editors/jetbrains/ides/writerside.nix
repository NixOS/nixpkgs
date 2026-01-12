# TODO: This IDE is deprecated and scheduled for removal in 26.05
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
      url = "https://download.jetbrains.com/writerside/writerside-243.22562.371.tar.gz";
      sha256 = "d49e58020d51ec4ccdbdffea5d42b5a2d776a809fc00789cef5abda7b23bd3f6";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/writerside/writerside-243.22562.371-aarch64.tar.gz";
      sha256 = "6067f6f73c4a178e2d0ae42bd18669045d85b5b5ed2c9115c2488ba7aa2a3d88";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/writerside/writerside-243.22562.371.dmg";
      sha256 = "0c78b8035497c855aea5666256716778abd46dadf68f51e4f91c0db01f62b280";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/writerside/writerside-243.22562.371-aarch64.dmg";
      sha256 = "9d86ef50b4c6d2a07d236219e9b05c0557241fb017d52ac395719bdb425130f5";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "writerside";

  wmClass = "jetbrains-writerside";
  product = "Writerside";

  # update-script-start: version
  version = "2024.3 EAP";
  buildNumber = "243.22562.371";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    musl
  ];

  # NOTE: meta attrs are currently used by the desktop entry, so changing them may cause rebuilds (see TODO in README)
  meta = {
    homepage = "https://www.jetbrains.com/writerside/";
    description = "Documentation IDE from JetBrains";
    longDescription = "The most powerful development environment – now adapted for writing documentation.";
    maintainers = with lib.maintainers; [ zlepper ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
