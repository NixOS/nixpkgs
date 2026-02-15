{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk_15,
}:

let
  executableName = "Caffeine";
in
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

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=deprecated-declarations"
  ];

  postPatch = ''
    substituteInPlace Info.plist \
      --replace-fail \''${EXECUTABLE_NAME} ${executableName} \
      --replace-fail $\(PRODUCT_BUNDLE_IDENTIFIER\) com.intelliscapesolutions.caffeine \
      --replace-fail \''${PRODUCT_NAME} ${executableName}
    # Update LSMinimumSystemVersion to 11.5 (based on value in upstream's pre-built app)
    sed -Ei '/<key>LSMinimumSystemVersion<\/key>/{n; s/(<string>)10.6(<\/string>)/\111.5\2/}' Info.plist
  '';

  buildPhase = ''
    runHook preBuild

    $CC \
      -ObjC \
      -framework Cocoa \
      -framework WebKit \
      -framework IOKit \
      -framework CoreServices \
      -framework ApplicationServices \
      -o ${executableName} \
      main.m \
      AppCategory.m \
      AppDelegate.m \
      ISToggleSwitch.m \
      LCMenuIconView.m

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    APPDIR=$out/Applications/${executableName}.app

    install -Dm755 ${executableName} "$APPDIR/Contents/MacOS/${executableName}"
    install -Dm644 Info.plist "$APPDIR/Contents/Info.plist"

    for resource in \
      AccessibilityPermission.gif \
      Caffeine.icns \
      Caffeine.sdef \
      active.png \
      active@2x.png \
      highlightactive.png \
      highlightactive@2x.png \
      highlighted.png \
      highlighted@2x.png \
      inactive.png \
      inactive@2x.png
    do
      install -Dm644 "$resource" "$APPDIR/Contents/Resources/$resource"
    done

    find English.lproj -type f -exec install -Dm644 "{}" "$APPDIR/Contents/Resources/{}" \;

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
