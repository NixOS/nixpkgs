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
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.1.1.tar.gz";
      hash = "sha256-OgZLIpYfPzm4ZrZLYoVY4ND3CNQjo/lWXUPw6BGWmXs=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.1.1-aarch64.tar.gz";
      hash = "sha256-h1FtLwe47B/2z+nRTWj8P3b11XuGYRMlueq6wbYEPMs=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.1.1.dmg";
      hash = "sha256-XMaynB2VjtB3xUSobmNGT7//HWkIcinZbwvIEn9Kdqo=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.1.1-aarch64.dmg";
      hash = "sha256-e9pi80XBGJL/lAaCu1nmDu5AZ0uy8s3GIEsuGyrTjfg=";
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
  version = "2025.3.1.1";
  buildNumber = "253.29346.240";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  extraLdPath = [ zlib ];
  extraWrapperArgs = [
    ''--set M2_HOME "${maven}/maven"''
    ''--set M2 "${maven}/maven/bin"''
  ];

  buildInputs = [
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
