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
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.4.tar.gz";
      hash = "sha256-i96xMtC10f1V55WvF5iovk0JtixILe5r2snX0iCWH8A=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.4-aarch64.tar.gz";
      hash = "sha256-lApU0A1aFqAU7+mT1etk7P+2IsSOBhrJgYUx9SYEpms=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.4.dmg";
      hash = "sha256-1Yf50KibE5b83wiuNmEwe+YknSRCZ9ANAoi4jU/vyDk=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.4-aarch64.dmg";
      hash = "sha256-mI3b1xu/fWbWBbb9/2TIhFSuSXvzYGCmQEgSQp8BaHg=";
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
  version = "2025.3.4";
  buildNumber = "253.32098.44";
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
