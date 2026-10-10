{
  lib,
  swiftPackages,
  swift,
  swiftpm,
  libicns,
  fetchSwiftPMDeps,
  fetchFromGitHub,
}:

swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "dinky";
  version = "0.28";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mikker";
    repo = "Dinky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q9LyyzlTQzNOtqZMPhpNSFZ5mKbr8fQDL3h5MtVCy1w=";
  };

  patches = [
    ./remove-sparkle.patch
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-oCxMSLRMIeVZbOgvbEJzY0HBEri0jRY5k7cyDJnXmm8=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
    libicns
  ];

  installPhase = ''
    runHook preInstall

    app=$out/Applications/dinky.app
    install -Dm755 "$(swiftpmBinPath)/dinky" $app/Contents/MacOS/dinky

    mkdir -p $app/Contents/Resources
    png2icns $app/Contents/Resources/Dinky.icns docs/assets/icon.png

    substitute Resources/Info.plist $app/Contents/Info.plist \
      --replace-fail '<string>VERSION</string>' '<string>${finalAttrs.version}</string>' \
      --replace-fail '<string>BUILD</string>' '<string>${finalAttrs.version}</string>' \
      --replace-fail '<key>LSUIElement</key>' \
                     '<key>CFBundleIconFile</key><string>Dinky</string><key>LSUIElement</key>'

    mkdir -p $out/bin
    ln -s $app/Contents/MacOS/dinky $out/bin/dinky

    runHook postInstall
  '';

  meta = {
    description = "tiling wm for macOS. No honey, we have hyprland at home";
    longDescription = ''
      Tiling window manager for macOS that leaves System Integrity Protection on
    '';
    homepage = "https://github.com/mikker/Dinky";
    changelog = "https://github.com/mikker/Dinky/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkapra ];
    platforms = lib.platforms.darwin;
    mainProgram = "dinky";
  };
})
