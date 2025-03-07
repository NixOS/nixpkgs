{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  jdk,
  jre,
}:

stdenv.mkDerivation {
  pname = "remnants-of-the-precursors";
  version = "1.04";

  src = fetchFromGitHub {
    owner = "rayfowler";
    repo = "rotp-public";
    rev = "e3726fc22c2c44316306c50c79779e3da1c4c140";
    sha256 = "sha256-oMA8LRpBoBX7t4G+HuRz0a8g+UEwYO7Ya0Qq4j8AWec=";
  };

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  # By default, the game tries to write to the java class path. If that fails
  # (and it always does, since they are in the read-only nix store), it won't
  # launch.
  patches = [ ./0001-store-config-and-saves-in-XDG_CONFIG_HOME.patch ];

  buildPhase = ''
    runHook preBuild

    javac -d "$out/share/" -sourcepath src src/rotp/Rotp.java

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # We need the assets, but don't want the source files.
    find "src/rotp" -type f -name '*java' -exec rm "{}" \;
    cp -r src/rotp/* "$out/share/rotp/"

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/rotp \
      --add-flags "-cp $out/share rotp.Rotp"

    runHook postInstall
  '';

  meta = with lib; {
    description = ''Open-source modernization of the 1993 classic "Master of Orion", written in Java'';
    homepage = "https://www.remnantsoftheprecursors.com/";

    # See LICENSE file in source repo for more details.
    license = with licenses; [
      # All java files created by Ray Fowler:
      gpl3Only

      # All Java files in the src/rotp/apachemath folder:
      asl20

      # The /src/rotp/model/planet/PlanetHeightMap.java file:
      #
      # This file is a Java-rewrite of the "Planet Generator" code (originally in C)
      # available from the following site:
      #
      #     http://hjemmesider.diku.dk/~torbenm/Planet
      #
      # That page includes the following statement: "Both the program itself and
      # maps created by the program are free for use, modification and reproduction,
      # both privately and for commercial purposes, as long as this does not limit
      # what other people may do with the program and the images they produce with
      # the program"
      {
        free = true;
        url = "http://hjemmesider.diku.dk/~torbenm/Planet";
      }

      # All image files are copyright by Peter Penev.
      #
      # All sound files are copyright by Remi Agullo.
      #
      # Various *.txt files that contain a license notice are copyright by Jeff Colucci. This
      # includes English text and any foreign language translations.
      #
      # The manual.pdf file is copyright by Tom Chick. This includes any foreign language
      # translations of the manual contained in this repository
      cc-by-nc-nd-40
    ];

    maintainers = with maintainers; [ jtrees ];
    platforms = [ "x86_64-linux" ];
  };
}
