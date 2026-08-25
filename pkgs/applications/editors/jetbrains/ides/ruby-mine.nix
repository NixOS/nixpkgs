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
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.1.tar.gz";
      hash = "sha256-cfHzTqHSPz9pwdZrrXAkZWQgD3mvAEBt8947UHaywOI=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.1-aarch64.tar.gz";
      hash = "sha256-cVvrUx00isFAS+LY8TFvAZGtlbSZdTcY0OR4OSCxBt0=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.1-aarch64.dmg";
      hash = "sha256-quCR0TsOazUk/Pp6M20ocPNYV+MElwJv80bC11iQo8o=";
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
  version = "2026.2.1";
  buildNumber = "262.9437.192";
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
