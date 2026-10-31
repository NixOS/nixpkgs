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
      url = "https://download.jetbrains.com/mps/2026.1/MPS-2026.1.2.tar.gz";
      hash = "sha256-KVAZUyqve4Tg52bzDlmMlhUqZiT0mmctAo5YZ3VoLVw=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/mps/2026.1/MPS-2026.1.2.tar.gz";
      hash = "sha256-KVAZUyqve4Tg52bzDlmMlhUqZiT0mmctAo5YZ3VoLVw=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/mps/2026.1/MPS-2026.1.2-macos.dmg";
      hash = "sha256-Xq7L4EYHQJoqRnNGxcGLgUEZxrsoI21uvc7108woPc0=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/mps/2026.1/MPS-2026.1.2-macos-aarch64.dmg";
      hash = "sha256-0wl/g5fafmQJ4B6qV2DU+ABECq+QrFkf3fXYqw3Leac=";
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
  version = "2026.1.2";
  buildNumber = "261.27258.1085";
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
