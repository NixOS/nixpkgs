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
  zulu25,
  udevCheckHook,
  desktopToDarwinBundle,
  imagemagick,
  librsvg,
}:
let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  # 7.4 targets Java 23 and JavaFX 25; zulu ships JavaFX prebuilt
  jdk = zulu25.override { enableJavaFX = true; };

in
maven.buildMavenPackage (finalAttrs: {
  pname = "ns-usbloader";
  version = "7.4";

  src = fetchFromGitHub {
    owner = "developersu";
    repo = "ns-usbloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5ZsJHDKtoRhXBmvjH2jwJaHtR1FuVA4A3YOWUEBC3P4=";
  };

  patches = [
    ./no-launch4j.patch
    ./make-deterministic.patch
  ];

  mvnJdk = jdk;

  # Upstream's aarch64 profile picks the aarch64 JavaFX and libusb4java builds
  mvnParameters = lib.optionalString stdenv.hostPlatform.isAarch64 "-Paarch64";

  # JavaFX pulls in architecture dependent jar dependencies. :(
  # May be possible to unify these, but could lead to huge closure sizes.
  mvnHash = selectSystem {
    x86_64-linux = "sha256-W6VIvpb1rkiIru24D2CqBdydlxl6bur+ZjkazATlUQ4=";
    aarch64-linux = "sha256-US8a9IPRg16zGPPgU9Xy21I/fTsmX+jYCXbL12hwOMw=";
    aarch64-darwin = "sha256-QtHDI2cnYzbCdjURu+/MX/k5YAMZ9WanqdL/wdbCDEE=";
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
  #   at build, but jar runs fine when using a JDK with JavaFX.

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
    install -Dm644 target/ns-usbloader-${finalAttrs.version}${lib.optionalString stdenv.hostPlatform.isAarch64 "-mac+linux-aarch64"}.jar $out/share/java/ns-usbloader.jar
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib/udev/rules.d
    install -Dm644 ${./99-ns-usbloader.rules} $out/lib/udev/rules.d/99-ns-usbloader.rules
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
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
    makeWrapper ${jdk}/bin/java $out/bin/ns-usbloader \
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
      comment = finalAttrs.meta.description;
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
    description = "All-in-one tool for managing Nintendo Switch homebrew";
    homepage = "https://github.com/developersu/ns-usbloader";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ soupglasses ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "ns-usbloader";
  };
})
