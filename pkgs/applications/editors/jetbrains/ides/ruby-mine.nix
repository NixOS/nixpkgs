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
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1.tar.gz";
      hash = "sha256-6esgEcotVpTFjAEWkL9UTQJuOnwcDI3puzehj6DPgRg=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1-aarch64.tar.gz";
      hash = "sha256-v2A8ahuh5hiv23BYlkhEfPzlO02qegzGgHPBt35yfVU=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1.dmg";
      hash = "sha256-T86EmDpqzhbYR5FQt2UoAlCiYLPST7NyWNEUAAxsERU=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2025.3.1-aarch64.dmg";
      hash = "sha256-Z/GqZ0uQ7FS6IfNSOtlAIY+Xm+/XQp44rYIryBRtFqQ=";
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
  version = "2025.3.1";
  buildNumber = "253.29346.140";
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
