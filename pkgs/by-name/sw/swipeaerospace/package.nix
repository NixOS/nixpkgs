{
  actool,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  lib,
  rcodesign,
  stdenv,
  swift,
  swiftpm,
}:

let
  infoPlist =
    version:
    lib.generators.toPlist { escape = true; } {
      CFBundleDevelopmentRegion = "en";
      CFBundleDisplayName = "SwipeAeroSpace";
      CFBundleExecutable = "SwipeAeroSpace";
      CFBundleIconFile = "AppIcon";
      CFBundleIconName = "AppIcon";
      CFBundleIdentifier = "club.mediosz.SwipeAeroSpace";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = "SwipeAeroSpace";
      CFBundlePackageType = "APPL";
      CFBundleShortVersionString = version;
      CFBundleSupportedPlatforms = [ "MacOSX" ];
      CFBundleVersion = "25";
      LSApplicationCategoryType = "public.app-category.developer-tools";
      LSMinimumSystemVersion = "13.5";
      LSUIElement = true;
      NSHumanReadableCopyright = "©Tricster";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "swipeaerospace";
  version = "0.4.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MediosZ";
    repo = "SwipeAeroSpace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CfdoHNE/lJ9md0Xm6Pio9P3coTgQtEoIwZ/uOeHeEgI=";
  };

  # The upstream lock file lacks BlueSocket, which our application target adds.
  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    postPatch = ''
      cp ${./Package.resolved} Package.resolved
    '';
    hash = "sha256-srbj9NXd7QKt8jGmLnNKf7tMoVjLk4Uv0eclunz1Pjo=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
    actool
    rcodesign
  ];

  postPatch = ''
    # Upstream only provides a test harness; use our manifest to build the app.
    cp ${./Package.swift} Package.swift
    cp ${./Package.resolved} Package.resolved
  '';

  swiftpmFlags = [
    "--product"
    "SwipeAeroSpace"
  ];

  installPhase = ''
    runHook preInstall

    app="$out/Applications/SwipeAeroSpace.app"
    mkdir -p "$app/Contents/"{MacOS,Resources}

    cp "$(swiftpmBinPath)/SwipeAeroSpace" "$app/Contents/MacOS/SwipeAeroSpace"
    printf '%s' ${lib.escapeShellArg (infoPlist finalAttrs.version)} > "$app/Contents/Info.plist"
    printf 'APPL????' > "$app/Contents/PkgInfo"

    actool --compile "$app/Contents/Resources" \
      --platform macosx \
      --minimum-deployment-target 13.5 \
      --app-icon AppIcon \
      --output-partial-info-plist /dev/null \
      SwipeAeroSpace/Assets.xcassets

    runHook postInstall
  '';

  postFixup = ''
    rcodesign sign \
      --code-signature-flags runtime \
      --entitlements-xml-file ${finalAttrs.src}/SwipeAeroSpace/SwipeAeroSpace.entitlements \
      "$out/Applications/SwipeAeroSpace.app"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Switch AeroSpace workspaces by swiping";
    homepage = "https://github.com/MediosZ/SwipeAeroSpace";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kinnrai ];
    platforms = lib.platforms.darwin;
  };
})
