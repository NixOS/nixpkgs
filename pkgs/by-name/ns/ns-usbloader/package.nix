{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  wrapGAppsHook3,
  gvfs,
  maven,
  jre,
  udevCheckHook,
  desktopToDarwinBundle,
  darwin,
  imagemagick,
  libusb1,
  librsvg,
}:
let
  pkgDescription = "All-in-one tool for managing Nintendo Switch homebrew";

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  jreWithJavaFX = jre.override { enableJavaFX = true; };
in
maven.buildMavenPackage rec {
  pname = "ns-usbloader";
  version = "7.2";

  src = fetchFromGitHub {
    owner = "developersu";
    repo = "ns-usbloader";
    rev = "v${version}";
    sha256 = "sha256-nZfAZ+IjoYXEWwH9oOhOQ5TOYUNiAGAqhHRhskyx/Vo=";
  };

  patches = [
    ./no-launch4j.patch
    ./make-deterministic.patch
  ];

  # JavaFX pulls in architecture dependent jar dependencies. :(
  # May be possible to unify these, but could lead to huge closure sizes.
  mvnHash = selectSystem {
    x86_64-linux = "sha256-vXZAlZOh9pXNF1RL78oQRal5pkXFRKDz/7SP9LibgiA=";
    aarch64-linux = "sha256-xC+feb41EPi30gBrVR8usanVULI2Pt0knztzNagPQiw=";
    aarch64-darwin = "sha256-n6JWWqEw/dvHogfAQCQsoaCyGaTpxEqIXwcrc6qyCgY=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
    gvfs
    udevCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
    darwin.sigtool
    imagemagick
    librsvg
  ];

  doCheck = false;

  doInstallCheck = true;

  # Don't wrap binaries twice.
  dontWrapGApps = true;

  ### Issues:
  # * Set us to only use software rendering with `-Dprism.order=sw`, had a hard time
  #   getting `prism_es2` happy with NixOS's GL/GLES.
  # * Currently, there's also a lot of `Failed to build parent project for org.openjfx:javafx-*`
  #   at build, but jar runs fine when using `jreWithJavaFX`.

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # The vendored usb4java native library for Apple Silicon links against
    # libusb from a hardcoded Homebrew prefix.
    dylib=src/main/resources/org/usb4java/darwin-aarch64/libusb4java.dylib
    install_name_tool -change \
      /opt/homebrew/opt/libusb/lib/libusb-1.0.0.dylib \
      ${lib.getLib libusb1}/lib/libusb-1.0.0.dylib \
      $dylib
    codesign -f -s - $dylib

    # Upstream's icon is full-bleed with square corners on one side. Fit it to
    # Apple's icon grid (an 824px rounded square with 185px corners on a 1024px
    # canvas) so it looks like other apps. JavaFX sets the Dock icon from the
    # PNGs inside the jar, so replace those too, before Maven packages them.
    rsvg-convert -w 824 -h 824 misc/freedesktop_entry/ns-usbloader.svg -o icon-art.png
    magick icon-art.png \
      \( -size 824x824 xc:none -fill white -draw "roundrectangle 0,0,823,823,185,185" \) \
      -compose DstIn -composite -compose Over \
      -background none -gravity center -extent 1024x1024 macos-icon.png
    for size in 32 48 64 128; do
      magick macos-icon.png -resize ''${size}x''${size} src/main/resources/res/app_icon''${size}x''${size}.png
    done
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    install -Dm644 target/ns-usbloader-${version}.jar $out/share/java/ns-usbloader.jar
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib/udev/rules.d
    install -Dm644 ${./99-ns-usbloader.rules} $out/lib/udev/rules.d/99-ns-usbloader.rules
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Keep libusb alive; its path is hidden inside the compressed jar.
    mkdir -p $out/nix-support
    echo ${lib.getLib libusb1} > $out/nix-support/depends

    # Every size desktopToDarwinBundle puts in the app bundle's .icns.
    for size in 16 32 128 256 512; do
      install -d $out/share/icons/hicolor/''${size}x''${size}/apps $out/share/icons/hicolor/''${size}x''${size}@2/apps
      magick macos-icon.png -resize ''${size}x''${size} $out/share/icons/hicolor/''${size}x''${size}/apps/ns-usbloader.png
      magick macos-icon.png -resize $((size * 2))x$((size * 2)) $out/share/icons/hicolor/''${size}x''${size}@2/apps/ns-usbloader.png
    done
  ''
  + ''

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
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    --add-flags "-Xdock:name=NS-USBLoader" \
    --add-flags "-Xdock:icon=$out/Applications/NS-USBLoader.app/Contents/Resources/ns-usbloader.icns" \
  ''
  + ''
    --add-flags "-Dprism.order=sw -jar $out/share/java/ns-usbloader.jar" \
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
      keywords = [
        "nintendo"
        "switch"
      ];
    })
  ];

  meta = {
    description = pkgDescription;
    homepage = "https://github.com/developersu/ns-usbloader";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ soupglasses ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "ns-usbloader";
  };
}
