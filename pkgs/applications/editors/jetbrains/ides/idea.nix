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
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.2.tar.gz";
      hash = "sha256-o0QsnxlTxm3LCCXpt4jH5077WG7b8dMO+LDfVT/hNuQ=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.2-aarch64.tar.gz";
      hash = "sha256-yu8YsKgqaxCEHozq0Ar8DEbuBUDwsWelPZwG7ZI3JiE=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.2.dmg";
      hash = "sha256-624WPcLwXqP/WsUss+6Upo1W7E504S/+BvtJcjTD9uY=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.2-aarch64.dmg";
      hash = "sha256-uaBXwFX6fd5Aa7+YB/yis2fwwdR3cd9qwGigf/23bsk=";
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
  version = "2025.3.2";
  buildNumber = "253.30387.90";
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
