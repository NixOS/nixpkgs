{
  # keep-sorted start
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  stdenv,
  # keep-sorted end
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/mps/2026.1/MPS-2026.1.tar.gz";
      hash = "sha256-NbURKu1jTPoJQvV8FpMacBa+FehF7XfF6xZmIhFlb2A=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/mps/2026.1/MPS-2026.1.tar.gz";
      hash = "sha256-NbURKu1jTPoJQvV8FpMacBa+FehF7XfF6xZmIhFlb2A=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/mps/2026.1/MPS-2026.1-macos-aarch64.dmg";
      hash = "sha256-5VtPS26/vCKa+mfDAQKgd9x5A+Cqv39Kz+2EKkgul+I=";
    };
  };
  # update-script-end: urls
in
jetbrains.mkJetBrainsProduct {
  inherit jetbrains-libdbm fsnotifier;

  pname = "mps";

  wmClass = "jetbrains-MPS";
  product = "MPS";

  # update-script-start: version
  version = "2026.1";
  buildNumber = "261.25134.779";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/mps/";
    description = "IDE for building domain-specific languages from JetBrains";
    longDescription = "A metaprogramming system which uses projectional editing which allows users to overcome the limits of language parsers, and build DSL editors, such as ones with tables and diagrams.";
    maintainers = [ ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
