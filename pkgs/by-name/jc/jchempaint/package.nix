{
  lib,
  maven,
  fetchFromGitHub,
  makeWrapper,
  jre,
  jdk,
  gettext,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

maven.buildMavenPackage {
  pname = "jchempaint";
  version = "3.4-SNAPSHOT-2026-04-24"; # "3.4-SNAPSHOT" is the version given in the pom.xml

  src = fetchFromGitHub {
    owner = "JChemPaint";
    repo = "jchempaint";
    rev = "f128d0d15be1bac4d324463f269cf130d2211253";
    hash = "sha256-pcHX6PdnD/jkLxAMSV/Ts8VVrK9xy2NWiMVVJ7jTrQc=";
  };

  mvnHash = "sha256-VpYSTN5u9IhCakak48HhbwnT3FhMpPKlwRZztiNGEIw=";

  nativeBuildInputs = [
    makeWrapper
    gettext
    jdk
    copyDesktopItems
  ];

  mvnParameters = "-DskipTests";

  installPhase = ''
    runHook preInstall

    # Create output directories
    mkdir -p $out/bin $out/share/jchempaint

    cp app-jar/target/JChemPaint.jar $out/share/jchempaint/jchempaint.jar

    # Create wrapper script
    makeWrapper ${jre}/bin/java $out/bin/jchempaint \
      --add-flags "-jar $out/share/jchempaint/jchempaint.jar"

    # install icons for desktop entry
    for size in 16 32 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      cp src_icons/JChemPaint.iconset/icon_''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/jchempaint.png
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "jchempaint";
      desktopName = "JChemPaint";
      exec = "jchempaint";
      icon = "jchempaint";
      categories = [
        "Science"
        "Education"
        "Chemistry"
      ];
      terminal = false;
      startupWMClass = "org-openscience-jchempaint-application-JChemPaint";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Chemical 2D structure editor application/applet based on the Chemistry Development Kit";
    homepage = "https://jchempaint.github.io";
    changelog = "https://github.com/JChemPaint/jchempaint/releases/tag/nightly";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ZZBaron ];
    mainProgram = "jchempaint";
  };
}
