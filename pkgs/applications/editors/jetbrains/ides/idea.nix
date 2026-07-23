{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  maven,
  zlib,
  lldb,
  musl,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIU-2026.1.4.tar.gz";
      hash = "sha256-MQTYXZUH/4ggZeP465UGQCtKgSkJLSaCZiu26cTwY/w=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIU-2026.1.4-aarch64.tar.gz";
      hash = "sha256-MDZFuLrUxcCIc0Zhi4QhgKPeU7Pgs9oJ/FxQH1n3gBM=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2026.1.4.dmg";
      hash = "sha256-8K+LiewiINP4S9eqV0kGWtfy2Ff/zvBwX89iX7mYZ78=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2026.1.4-aarch64.dmg";
      hash = "sha256-XIBK/+Lxaz9dX+Lxl7HXsl+Z3Z7GBzSuDxNssb/4A2s=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "idea";

  wmClass = "jetbrains-idea";
  product = "IntelliJ IDEA";
  productShort = "IDEA";

  # update-script-start: version
  version = "2026.1.4";
  buildNumber = "261.26222.65";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  extraLdPath = [ zlib ];
  extraWrapperArgs = [
    ''--set M2_HOME "${maven}/maven"''
    ''--set M2 "${maven}/maven/bin"''
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    lldb
    musl
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/idea/";
    description = "Java, Kotlin, Groovy and Scala IDE from JetBrains";
    longDescription = ''
      IDE for Java SE, Groovy & Scala development Powerful environment for building Google Android apps Integration with JUnit, TestNG, popular SCMs, Ant & Maven.
      Also known as IntelliJ.
    '';
    maintainers = with lib.maintainers; [
      gytis-ivaskevicius
      tymscar
    ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
