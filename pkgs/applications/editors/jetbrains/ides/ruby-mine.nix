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
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.4.tar.gz";
      hash = "sha256-Zk90LP0wGgVcO7xP/H3iLvEy3fVZJZuoFx2Sn9xGD0o=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.4-aarch64.tar.gz";
      hash = "sha256-/ALamV/6nwp7mku5NvuM6XMhWZmFif700hZx7OYD8M8=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.4.dmg";
      hash = "sha256-AHw06VBoXzBvRbEN9RwxYqtP1ZqlXIZj1hgJt9Z20wo=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/ruby/RubyMine-2026.2.4-aarch64.dmg";
      hash = "sha256-Ocm5nntn4Kq+xffIpv/asNuEXR99mY1H+YE/7ANDafc=";
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
  version = "2026.2.4";
  buildNumber = "262.11879.97";
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
