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
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.1.tar.gz";
      hash = "sha256-BZsRMuFek5UEo16GHFcEd6gki1IaftWPA692mgefOXo=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.1-aarch64.tar.gz";
      hash = "sha256-0bPG2f/RmUO8ZmxNtsEiXGdSahn4aVw/0OHCuGuMJDY=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.1.dmg";
      hash = "sha256-3FC80XSQ/zLPGLw/ois45ikZ2Y0a25/eWEqlbd1TyI8=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.1-aarch64.dmg";
      hash = "sha256-xD+JYmiudMJGCCJB3Pf8+mNGURJFRxMDh+Nj7xUrfz8=";
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
  version = "2026.1";
  buildNumber = "261.22158.284";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
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
