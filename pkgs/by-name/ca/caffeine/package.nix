{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk_15,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "caffeine";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "IntelliScape";
    repo = "caffeine";
    tag = "${finalAttrs.version}";
    sha256 = "sha256-AmBPY5ZVWBq2ZesNvvJ/Do5XgPjb5R1ESNJm7tx0M6k=";
  };

  buildInputs = [
    apple-sdk_15
  ];

  buildPhase = ''
    runHook preBuild

    $CC \
      -ObjC \
      -framework Cocoa \
      -o Caffeine \
      main.m

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    BINNAME=Caffeine
    APPDIR=$out/Applications/Caffeine.app
    mkdir -p "$APPDIR/Contents/MacOS" "$APPDIR/Contents/Resources"

    mv $BINNAME $APPDIR/Contents/MacOS

    substitute Info.plist $APPDIR/Contents/Info.plist \
      --replace-fail \''${EXECUTABLE_NAME} $BINNAME \
      --replace-fail $\(PRODUCT_BUNDLE_IDENTIFIER\) com.intelliscapesolutions.caffeine \
      --replace-fail \''${PRODUCT_NAME} Caffeine
    # Update LSMinimumSystemVersion to 11.5 (based on value in upstream's pre-built app)
    sed -Ei '/<key>LSMinimumSystemVersion<\/key>/{n; s/(<string>)10.6(<\/string>)/\111.5\2/}' $APPDIR/Contents/Info.plist

    cp -r \
      AccessibilityPermission.gif \
      Caffeine.icns \
      Caffeine.sdef \
      English.lproj \
      active.png \
      active@2x.png \
      highlightactive.png \
      highlightactive@2x.png \
      highlighted.png \
      highlighted@2x.png \
      inactive.png \
      inactive@2x.png \
      $APPDIR/Contents/Resources
    # Remove execute permission on resource files
    find $APPDIR/Contents/Resources -type f -exec chmod a-x {} +

    runHook postInstall
  '';

  meta = {
    description = "Don't let your Mac fall asleep";
    homepage = "https://intelliscapesolutions.com/apps/caffeine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
