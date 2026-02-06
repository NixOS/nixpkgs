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
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.2.tar.gz";
      hash = "sha256-CUiJ/TRFOpcXSp1JhqpFQQvo0baOLmy2GRaWlDx1uQU=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.2-aarch64.tar.gz";
      hash = "sha256-mR+3C4UBBlVeL/wO0uLNTv8U5HAHl7huVNyvNDFPRAw=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.2.dmg";
      hash = "sha256-bhK9MPiMN8zSEgg2UFAEAoXLJE0yBd/+VnGCCd25mtg=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.2-aarch64.dmg";
      hash = "sha256-u4XLyBR9p5/k5UZ3ZWB42JxlTqax75logTzJ6Av23Y0=";
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
  version = "2025.3.2";
  buildNumber = "253.30387.79";
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
