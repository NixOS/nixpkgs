{ lib, stdenv, fetchurl, fetchFromGitHub, jdk, jre, gradle, bash, coreutils, substituteAll, nixosTests, fetchpatch, writeText }:

# Refer to https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/gradle.section.md for packaging details

stdenv.mkDerivation rec {
  pname = "haveno";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "haveno-dex";
    repo = "haveno";
    rev = version;
    hash = "sha256-5ENXC6SWPt08ZixbHHdNAMkjVIXOodk+/Y1hgQ9fm68=";
  };

  # postPatch = ''
  #   rm gradle/verification-{keyring.keys,metadata.xml}
  # '';

  nativeBuildInputs = [ gradle jdk ];

  # wrapper = substituteAll {
  #   src = ./havenoWrapper;
  #   inherit bash coreutils jre;
  # };

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk}"
    "-Dfile.encoding=utf-8"
  ];

  gradleBuildTask = "jar";

  # will run the gradleCheckTask (defaults to "test")
  doCheck = true;

  # installPhase = ''
  #   mkdir -p $out/{bin,share/haveno}
  #   cp build/libs/haveno-all.jar $out/share/haveno

  #   makeWrapper ${jre}/bin/java $out/bin/haveno \
  #     --add-flags "-jar $out/share/haveno/haveno-all.jar"

  #   cp ${src}/haveno.1 $out/share/man/man1
  # '';

  # installPhase = ''
  #   runHook preInstall
  #   install -Dm444 build/libs/freenet.jar $out/share/freenet/freenet.jar
  #   ln -s ${freenet_ext} $out/share/freenet/freenet-ext.jar
  #   mkdir -p $out/bin
  #   install -Dm555 ${wrapper} $out/bin/freenet
  #   substituteInPlace $out/bin/freenet \
  #     --subst-var-by outFreenet $out
  #   runHook postInstall
  # '';

  # passthru.tests = { inherit (nixosTests) freenet; };

  meta = {
    description = "A decentralized monero exchange network";
    homepage = "https://haveno.exchange";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juaningan emmanuelrosa ];
    platforms = with lib.platforms; linux;
    # changelog = "";
  };
}
