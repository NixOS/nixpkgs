{
  # keep-sorted start
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  musl,
  stdenv,
  # keep-sorted end
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.3.tar.gz";
      hash = "sha256-wOfrb2saU+kbomylvgH2YxBN+i9DbUzCq+xGvqJEMcw=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.3-aarch64.tar.gz";
      hash = "sha256-UrGqkzYTzzjS8cVZF/SxEoQT5FgGj9fz6O8NyUDORCY=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.3-aarch64.dmg";
      hash = "sha256-5PMBrgHCxq6N8F3BYX+3lbA3gn781IaKOowsO4XY4jI=";
    };
  };
  # update-script-end: urls
in
jetbrains.mkJetBrainsProduct {
  inherit jetbrains-libdbm fsnotifier;

  pname = "ruby-mine";

  wmClass = "jetbrains-rubymine";
  product = "RubyMine";

  # update-script-start: version
  version = "2026.2.3";
  buildNumber = "262.10968.66";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    musl
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/ruby/";
    description = "Ruby IDE from JetBrains";
    longDescription = "Ruby IDE from JetBrains";
    maintainers = with lib.maintainers; [ tymscar ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
