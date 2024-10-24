{ lib, stdenv, fetchFromGitHub, jdk, jre, gradle, bash, coreutils, substituteAll, nixosTests, fetchpatch, writeText, makeDesktopItem, ... }:

# Refer to https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/gradle.section.md for packaging details

stdenv.mkDerivation rec {
  pname = "haveno";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "haveno-dex";
    repo = "haveno";
    rev = version;
    hash = "sha256-DGpnDyCrelGpyQ8RPhHu7WlQEcNyRHblr8IAUFGVL+A=";
  };

  nativeBuildInputs = [ gradle jdk ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  desktopItem = makeDesktopItem {
    name = "Haveno";
    desktopName = "Haveno";
    exec = "haveno";
    icon = "haveno";
    # REVIEW(Krey): Propose which category this should be using
    categories = [ "Game" ];
  };

  gradleFlags = [
    # TODO(Krey): Is this needed?
    "-Dorg.gradle.java.home=${jdk}"

    "-Dfile.encoding=utf-8"
  ];

  # REVIEW(Krey): No idea what this should be set to
  # gradleBuildTask = "shadowJar";

  # will run the gradleCheckTask (defaults to "test")
  doCheck = true;

  # TODO(Krey): Implementation blocked by https://github.com/haveno-dex/haveno/issues/1206
  # installPhase = ''
  #   mkdir -p $out/{bin,share/haveno}
  #   cp build/libs/haveno-all.jar $out/share/haveno

  #   makeWrapper ${jre}/bin/java $out/bin/haveno \
  #     --add-flags "-jar $out/share/haveno/haveno-all.jar"

  #   cp ${src}/haveno.1 $out/share/man/man1
  # '';

  meta = {
    description = "A decentralized monero exchange network";
    homepage = "https://haveno.exchange";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juaningan emmanuelrosa ];
    platforms = with lib.platforms; linux;
    # changelog = "";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
}
