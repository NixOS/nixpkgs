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
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1.tar.gz";
      sha256 = "e9eb2011ca2d5694c58c011690bf544d026e3a7c1c0c8de9bb37a18fa0cf8118";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1-aarch64.tar.gz";
      sha256 = "bf603c6a1ba1e618afdb70589648447cfce53b4daa7a0cc68073c1b77e727d55";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1.dmg";
      sha256 = "4fce84983a6ace16d8479150b765280250a260b3d24fb37258d114000c6c1115";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1-aarch64.dmg";
      sha256 = "67f1aa674b90ec54ba21f3523ad940218f979befd7429e38ad822bc8146d16a4";
    };
  };
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "ruby-mine";

  wmClass = "jetbrains-rubymine";
  product = "RubyMine";

  version = "2025.3.1";
  buildNumber = "253.29346.140";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    musl
  ];

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
