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
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.1.tar.gz";
      sha256 = "21e1b90b5ec684767a03498ba424ef3f9acc5dbf759cceefd5edd474f043ad6c";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.1-aarch64.tar.gz";
      sha256 = "095711329d1e9c14641ba426e652d4dbd3885b27c9a046e44725ae677491e8c3";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.1.dmg";
      sha256 = "adf5af3839e07ba6387bf0eca94df2f44c829023a1898170eacbc5cbafce0393";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIU-2025.3.1-aarch64.dmg";
      sha256 = "2137863cc3a5f4acd25ba38a82e004e935d3a94fa566f8e3851d6b8a8ac12777";
    };
  };
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "idea";

  wmClass = "jetbrains-idea";
  product = "IntelliJ IDEA";
  productShort = "IDEA";

  version = "2025.3.1";
  buildNumber = "253.29346.138";

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

  meta = {
    homepage = "https://www.jetbrains.com/idea/";
    description = "Java, Kotlin, Groovy and Scala IDE from Jetbrains";
    longDescription = "IDE for Java SE, Groovy & Scala development Powerful environment for building Google Android apps Integration with JUnit, TestNG, popular SCMs, Ant & Maven. Also known as IntelliJ.";
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
