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
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.4.tar.gz";
      hash = "sha256-uG3a46P9bCr7rKFgo7fVT0tPptE2GsJha9t6ZBZjLqE=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.4-aarch64.tar.gz";
      hash = "sha256-d72Gs32hU20h66HsvmL10uI9+vliAbJOEVqxi5hzepI=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.4.dmg";
      hash = "sha256-cYDCzPYh1/S77SCx9xctQfBQYSv2aS0o7VOeu+7limQ=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.4-aarch64.dmg";
      hash = "sha256-POxaLX5XfjIIEGAe7Qv2mpYo8/G4KjPkC/ZHIjG/xrg=";
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
  version = "2025.3.4";
  buildNumber = "253.32098.37";
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
