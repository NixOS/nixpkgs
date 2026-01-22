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
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1.1.tar.gz";
      hash = "sha256-dVd/4LBssEsuzEB+RX44RCrlXfNOyYkRPe3SvOD+N20=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1.1-aarch64.tar.gz";
      hash = "sha256-FNco8STJ+HEmcfZFpFiDzM0QYQPxchmPizAPqYHiYWo=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1.1.dmg";
      hash = "sha256-FWHsKzpmvr3CHCcB5nhHKq9NRWVP+IyPGuk2lunLDKU=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1.1-aarch64.dmg";
      hash = "sha256-K66IoMXqfs1frfo+gUCKQrp9pIm2iFyLNdFFNkHPYPc=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "ruby-mine";

  wmClass = "jetbrains-rubymine";
  product = "RubyMine";

  # update-script-start: version
  version = "2025.3.1.1";
  buildNumber = "253.29346.331";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    musl
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/ruby/";
    description = "Ruby IDE from JetBrains";
    longDescription = "Ruby IDE from JetBrains";
    maintainers = with lib.maintainers; [ tymscar ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
