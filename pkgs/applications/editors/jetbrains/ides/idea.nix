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
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.tar.gz";
      hash = "sha256-E/QXS6FsHO8EhxyyYUM1NtACWGwmmoCTksIO4/lJWfU=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3-aarch64.tar.gz";
      hash = "sha256-B8g6nSGfqJRbasy38yhGWFU+XIEgU6l2Ibj4S8Ax5Xw=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.dmg";
      hash = "sha256-AHUK4cG5D434EWv8/fSYrsntCxkDbQ7aAlo6m4nLXXk=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3-aarch64.dmg";
      hash = "sha256-IUa39eM9jqto2RR6FbbfEbPAez5hMPNRwLFgacLm+u0=";
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
  version = "2025.3";
  buildNumber = "253.28294.334";
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
