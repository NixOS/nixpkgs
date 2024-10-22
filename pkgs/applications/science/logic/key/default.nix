{ lib, stdenv
, fetchurl
, jdk
, gradle_7
, jre
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, testers
, key
}:

let
  gradle = gradle_7;

in stdenv.mkDerivation rec {
  pname = "key";
  version = "2.10.0";
  src = fetchurl {
    url = "https://www.key-project.org/dist/${version}/key-${version}-sources.tgz";
    sha256 = "1f201cbcflqd1z6ysrkh3mff5agspw3v74ybdc3s2lfdyz3b858w";
  };
  sourceRoot = "key-${version}/key";

  nativeBuildInputs = [
    jdk
    gradle_7
    makeWrapper
    copyDesktopItems
  ];

  executable-name = "KeY";

  desktopItems = [
    (makeDesktopItem {
      name = "KeY";
      exec = executable-name;
      icon = "key";
      comment = meta.description;
      desktopName = "KeY";
      genericName = "KeY";
      categories = [ "Science" ];
    })
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  # tests are broken on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp key.ui/build/libs/key-*-exe.jar $out/share/java/KeY.jar
    mkdir -p $out/bin
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp key.ui/src/main/resources/de/uka/ilkd/key/gui/images/key-color-icon-square.png $out/share/icons/hicolor/256x256/apps/key.png
    makeWrapper ${jre}/bin/java $out/bin/KeY \
      --add-flags "-cp $out/share/java/KeY.jar de.uka.ilkd.key.core.Main"

    runHook postInstall
  '';

  passthru.tests.version =
    testers.testVersion {
      package = key;
      command = "KeY --help";
    };

  meta = with lib; {
    description = "Java formal verification tool";
    homepage = "https://www.key-project.org"; # also https://formal.iti.kit.edu/key/
    longDescription = ''
      The KeY System is a formal software development tool that aims to
      integrate design, implementation, formal specification, and formal
      verification of object-oriented software as seamlessly as possible.
      At the core of the system is a novel theorem prover for the first-order
      Dynamic Logic for Java with a user-friendly graphical interface.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = executable-name;
    platforms = platforms.all;
  };
}
