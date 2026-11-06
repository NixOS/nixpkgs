{
  actool,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix-update-script,
  rcodesign,
  stdenv,
  swift,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "powertop-macos";
  version = "1.4.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kDolphin";
    repo = "PowerTop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GZT/FfaDOymdREv6maQ7rBERJl5z20pEGG9xeygBSlw=";
  };

  nativeBuildInputs = [
    actool
    makeWrapper
    rcodesign
    swift
  ];

  dontConfigure = true;

  # Mirrors upstream's build.sh, which hardcodes Xcode paths and an arm64 target.
  buildPhase = ''
    runHook preBuild

    shopt -s globstar

    # Without -target, swiftc defaults to the build host's macOS major version.
    swiftc \
      -target ${stdenv.hostPlatform.swift.triple} \
      -O \
      -parse-as-library \
      -module-name PowerTop \
      -framework AppKit \
      -framework CoreFoundation \
      -framework Foundation \
      -framework IOKit \
      -framework ServiceManagement \
      -framework SwiftUI \
      PowerTop/**/*.swift \
      -o PowerTop-bin

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app="$out/Applications/PowerTop.app"
    mkdir -p "$app/Contents/"{MacOS,Resources}

    install -Dm755 PowerTop-bin "$app/Contents/MacOS/PowerTop"
    cp PowerTop/Info.plist "$app/Contents/Info.plist"
    cp -R PowerTop/*.lproj "$app/Contents/Resources/"

    actool --compile "$app/Contents/Resources" \
      --platform macosx \
      --minimum-deployment-target ${stdenv.hostPlatform.darwinMinVersion} \
      --app-icon AppIcon \
      --output-partial-info-plist /dev/null \
      PowerTop/Assets.xcassets

    makeWrapper "$app/Contents/MacOS/PowerTop" "$out/bin/powertop-macos"

    runHook postInstall
  '';

  postFixup = ''
    ${lib.getExe rcodesign} sign "$out/Applications/PowerTop.app"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/kDolphin/PowerTop/releases/tag/v${finalAttrs.version}";
    description = "Menu bar app for monitoring MacBook power usage";
    homepage = "https://github.com/kDolphin/PowerTop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mnixry ];
    mainProgram = "powertop-macos";
    platforms = lib.platforms.darwin;
  };
})
