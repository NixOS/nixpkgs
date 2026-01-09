# TODO: This IDE is deprecated and scheduled for removal in 26.05
{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  maven,
  zlib,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIC-2025.2.5.tar.gz";
      sha256 = "995c334cc3e143f13467abafef07a1ccf7d06275512bb6f4c91123948786ab7c";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/idea/ideaIC-2025.2.5-aarch64.tar.gz";
      sha256 = "4c57a783f31ee6f2c82d8c43bb5d0334a9afbc8bfb4542e732048c41f61e63a0";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIC-2025.2.5.dmg";
      sha256 = "ff48a1e60869342a91db867fa482a49d4cdf38476496911c109f34a7e8d6523d";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/idea/ideaIC-2025.2.5-aarch64.dmg";
      sha256 = "52065492d433f0ea9df4debd5f0683154ab4dab5846394cabc8a49903d70e5bc";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "idea-community";

  wmClass = "jetbrains-idea-ce";
  product = "IntelliJ IDEA CE";
  productShort = "IDEA";

  # update-script-start: version
  version = "2025.2.5";
  buildNumber = "252.28238.7";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  extraLdPath = [ zlib ];
  extraWrapperArgs = [
    ''--set M2_HOME "${maven}/maven"''
    ''--set M2 "${maven}/maven/bin"''
  ];

  # NOTE: meta attrs are currently used by the desktop entry, so changing them may cause rebuilds (see TODO in README)
  meta = {
    homepage = "https://www.jetbrains.com/idea/";
    description = "Free Java, Kotlin, Groovy and Scala IDE from Jetbrains (built from source)";
    longDescription = "IDE for Java SE, Groovy & Scala development Powerful environment for building Google Android apps Integration with JUnit, TestNG, popular SCMs, Ant & Maven. Also known as IntelliJ.";
    maintainers = with lib.maintainers; [
      gytis-ivaskevicius
      tymscar
    ];
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
