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
      url = "https://download.jetbrains.com/idea/ideaIU-2026.2.4.tar.gz";
      hash = "sha256-zGsp3bgsfcxlbVxyjO+yyResdn60uDaPEghzKEb7tb0=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIU-2026.2.4-aarch64.tar.gz";
      hash = "sha256-FYuX37w6iAdfoU/PX58sF7M59FJ+QkWzozyvGAUMKuI=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2026.2.4.dmg";
      hash = "sha256-V4cvSWsdVXLq5F5cIi27IsVYwasLON+o9KmvZqS962g=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2026.2.4-aarch64.dmg";
      hash = "sha256-d+QqNE34FpJuy+dufE4GdPY/1x5+oFloAaU8kylFidg=";
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
  version = "2026.2.4";
  buildNumber = "262.11879.100";
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
