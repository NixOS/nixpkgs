{
  actool,
  darwin,
  fetchFromGitHub,
  lib,
  nix-update-script,
  swiftPackages,
}:

let
  inherit (swiftPackages) stdenv swift;

  infoPlist =
    version:
    lib.generators.toPlist { escape = true; } {
      CFBundleDevelopmentRegion = "en";
      CFBundleDisplayName = "Ethernet Connection Status";
      CFBundleExecutable = "Ethernet Connection Status";
      CFBundleIconFile = "AppIcon";
      CFBundleIconName = "AppIcon";
      CFBundleIdentifier = "com.example.EthernetConnectionStatus";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = "Ethernet Connection Status";
      CFBundlePackageType = "APPL";
      CFBundleShortVersionString = version;
      CFBundleVersion = "1";
      LSApplicationCategoryType = "public.app-category.utilities";
      LSMinimumSystemVersion = "13.0";
      LSUIElement = true;
      NSHumanReadableCopyright = "Copyright © 2025. All rights reserved.";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ethernet-connection-status";
  version = "1.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "montanaflynn";
    repo = "EthernetConnectionStatus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ecxliuc6U5tJjFYsZDT7LxvJlbuNgKSYF+nuQUDIxGQ=";
  };

  postPatch = ''
    # Swift preview macros require Xcode's Swift compiler plugin.
    sed -i '/^#Preview {$/,$d' SettingsView.swift
  '';

  nativeBuildInputs = [
    actool
    darwin.autoSignDarwinBinariesHook
    swift
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    swiftc \
      -O \
      -swift-version 5 \
      -parse-as-library \
      -module-name EthernetConnectionStatus \
      -Xlinker -platform_version -Xlinker macos -Xlinker 13.0 -Xlinker 14.0 \
      -framework AppKit \
      -framework Foundation \
      -framework SwiftUI \
      -framework SystemConfiguration \
      EthernetIcon.swift \
      MacMenuBarApp.swift \
      NetworkMonitor.swift \
      SettingsView.swift \
      -o "Ethernet Connection Status"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app="$out/Applications/Ethernet Connection Status.app"
    mkdir -p "$app/Contents/"{MacOS,Resources}

    cp "Ethernet Connection Status" "$app/Contents/MacOS/"
    printf '%s' ${lib.escapeShellArg (infoPlist finalAttrs.version)} > "$app/Contents/Info.plist"
    printf 'APPL????' > "$app/Contents/PkgInfo"

    actool --compile "$app/Contents/Resources" \
      --platform macosx \
      --minimum-deployment-target 13.0 \
      --app-icon AppIcon \
      --output-partial-info-plist /dev/null \
      Media.xcassets

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native macOS menu bar app that monitors Ethernet connection status";
    homepage = "https://github.com/montanaflynn/EthernetConnectionStatus";
    changelog = "https://github.com/montanaflynn/EthernetConnectionStatus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tpansino ];
    platforms = lib.platforms.darwin;
  };
})
