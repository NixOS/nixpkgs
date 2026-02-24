{
  lib,
  jdk21,
  openjfx21,
  maven,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  gtk3,
}:

let
  jdkWithJFX =
    if jdk21.pname == "openjdk" then
      jdk21.override {
        enableJavaFX = true;
        openjfx21 = openjfx21.override { withWebKit = true; };
      }
    else
      throw "bad jdk variant";
in
maven.buildMavenPackage rec {
  pname = "sportstracker";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "ssaring";
    repo = "sportstracker";
    rev = "SportsTracker-${version}";
    hash = "sha256-5TRTZmBwu33CJieYyt4OtlzVjlfY1FLef9WwKl9iUIw=";
  };

  patches = [
    # We use nixpkgs's JavaFX instead of the one originally fetched by Maven,
    # so we don't even need to fetch it. This avoids having platform-dependent hashes.
    ./remove-pom-jfx.patch
    ./fix-maven-plugin-versions.patch
  ];

  mvnJdk = jdkWithJFX;
  mvnHash = "sha256-dAANjxM9cEEw+y3tOLHykxjdlVQh8I7pd/9k3lbkgzY=";

  mvnParameters = toString [
    "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z" # set fixed build timestamp for deterministic jar
    "-Dtest=!BindingUtilsToggleGroupTest" # uses DISPLAY
  ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
  ];

  buildInputs = [ gtk3 ];

  installPhase = ''
    runHook preInstall

    install -Dm644 sportstracker/target/sportstracker-*.jar $out/share/sportstracker/sportstracker.jar
    install -Dm644 sportstracker/target/lib/*.jar -t $out/share/sportstracker/lib
    install -Dm644 sportstracker/docs/* -t $out/share/doc/sportstracker
    install -Dm644 st-packager/icons/linux/SportsTracker.png -t $out/share/pixmaps

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "sportstracker";
      exec = "SportsTracker";
      icon = "SportsTracker";
      desktopName = "SportsTracker";
      comment = meta.description;
      terminal = false;
      categories = [
        "Sports"
        "Utility"
      ];
    })
  ];

  # don't double-wrap
  dontWrapGApps = true;

  postFixup = ''
    makeWrapper ${jdkWithJFX}/bin/java $out/bin/SportsTracker \
        --add-flags "-Djava.awt.headless=true" \
        --add-flags "-jar $out/share/sportstracker/sportstracker.jar" \
        "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    changelog = "https://www.saring.de/sportstracker/CHANGES.txt";
    description = "Desktop application for people who want to record and analyze their sporting activities";
    homepage = "https://www.saring.de/sportstracker";
    license = lib.licenses.gpl2Only;
    mainProgram = "SportsTracker";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = jdkWithJFX.meta.platforms;
  };
}
