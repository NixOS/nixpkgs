{ lib
, stdenv
, fetchFromGitHub
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, wrapGAppsHook3
, gvfs
, maven
, jre
}:
let
  pkgDescription = "All-in-one tool for managing Nintendo Switch homebrew";

  selectSystem = attrs:
    attrs.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  jreWithJavaFX = jre.override { enableJavaFX = true; };
in
maven.buildMavenPackage rec {
  pname = "ns-usbloader";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "developersu";
    repo = "ns-usbloader";
    rev = "v${version}";
    sha256 = "sha256-gSf5SCIhcUEYGsYssXVGjUweVU+guxOI+lzD3ANr96w=";
  };

  patches = [ ./no-launch4j.patch ./make-deterministic.patch ];

  # JavaFX pulls in architecture dependent jar dependencies. :(
  # May be possible to unify these, but could lead to huge closure sizes.
  mvnHash = selectSystem {
    x86_64-linux = "sha256-vXZAlZOh9pXNF1RL78oQRal5pkXFRKDz/7SP9LibgiA=";
    aarch64-linux = "sha256-xC+feb41EPi30gBrVR8usanVULI2Pt0knztzNagPQiw=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    wrapGAppsHook3
    gvfs
  ];

  doCheck = false;

  # Don't wrap binaries twice.
  dontWrapGApps = true;

  ### Issues:
  # * Set us to only use software rendering with `-Dprism.order=sw`, had a hard time
  #   getting `prism_es2` happy with NixOS's GL/GLES.
  # * Currently, there's also a lot of `Failed to build parent project for org.openjfx:javafx-*`
  #   at build, but jar runs fine when using `jreWithJavaFX`.

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    install -Dm644 target/ns-usbloader-${version}.jar $out/share/java/ns-usbloader.jar

    mkdir -p $out/lib/udev/rules.d
    install -Dm644 ${./99-ns-usbloader.rules} $out/lib/udev/rules.d/99-ns-usbloader.rules

    mkdir -p $out/share/icons/hicolor
    install -Dm644 target/classes/res/app_icon32x32.png $out/share/icons/hicolor/32x32/apps/ns-usbloader.png
    install -Dm644 target/classes/res/app_icon48x48.png $out/share/icons/hicolor/48x48/apps/ns-usbloader.png
    install -Dm644 target/classes/res/app_icon64x64.png $out/share/icons/hicolor/64x64/apps/ns-usbloader.png
    install -Dm644 target/classes/res/app_icon128x128.png $out/share/icons/hicolor/128x128/apps/ns-usbloader.png

    runHook postInstall
  '';

  preFixup = ''
    mkdir -p $out/bin
    makeWrapper ${jreWithJavaFX}/bin/java $out/bin/ns-usbloader \
      --append-flags "-Dprism.order=sw -jar $out/share/java/ns-usbloader.jar" \
      "''${gappsWrapperArgs[@]}"
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "ns-usbloader";
      desktopName = "NS-USBLoader";
      comment = pkgDescription;
      exec = "ns-usbloader";
      icon = "ns-usbloader";
      categories = [ "Game" ];
      terminal = false;
      keywords = [ "nintendo" "switch" ];
    })
  ];

  meta = with lib; {
    description = pkgDescription;
    homepage = "https://github.com/developersu/ns-usbloader";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ soupglasses ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "ns-usbloader";
  };
}
