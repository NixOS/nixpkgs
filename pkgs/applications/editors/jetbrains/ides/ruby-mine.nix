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
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.1.3.tar.gz";
      hash = "sha256-0KF/IEVRT8kgHpULEmqMy9gOf06IIDA4vEV3RujjQoE=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.1.3-aarch64.tar.gz";
      hash = "sha256-kiuRp9JhdS0aUFPX1brI1T9ik/iWhglIckHvv4bdPWk=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.1.3.dmg";
      hash = "sha256-UjpwMCXhI+bMOvyyEbRBoNW3GGCDpi7aF6hUxffW/h0=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.1.3-aarch64.dmg";
      hash = "sha256-lqa3L+rBiEH/hPmFcevWBumvvyBBzoUR3ttvA8s0uT0=";
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
  version = "2026.1.3";
  buildNumber = "261.25134.97";
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
