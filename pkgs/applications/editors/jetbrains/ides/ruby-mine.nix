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
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.2.tar.gz";
      hash = "sha256-Z9TbuDpoQCdpJO8rRAJbUmsemTZAuPcbVKJ3LqoulNY=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.2-aarch64.tar.gz";
      hash = "sha256-z4iI1wWHVHM/wcEYGyiJJtlzGU2h9poWMsZNEb1gvN4=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.2-aarch64.dmg";
      hash = "sha256-17XuJNgU2yBsfra62LfjG0HxN6HbdRzdSQUB9vuo4VM=";
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
  version = "2026.2.2";
  buildNumber = "262.10315.129";
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
