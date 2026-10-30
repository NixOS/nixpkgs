{
  lib,
  stdenv,
  fetchFromGitHub,
  swift,
  swiftpm,
  apple-sdk_26,
  darwinMinVersionHook,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  goose-cli,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "block-catch";
  version = "0.5.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "catch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ic0d0i1mgTWFEGaDqNwml36f0hfDcMVP+KNEx2yTxaA=";
  };

  # The Xcode canvas preview (#Preview) needs the PreviewsMacros plugin, which ships with Xcode and
  # not with the open-source toolchain; keep its body as a plain function (block/catch#6). The body
  # builds MainActor views, as the macro's closure did.
  postPatch = ''
    substituteInPlace Sources/Catch/Views/MainView.swift \
      --replace-fail '#Preview("Main View") {' '@MainActor private func mainViewPreview() -> some View {'
  '';

  nativeBuildInputs = [
    swift
    swiftpm
    makeBinaryWrapper
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    apple-sdk_26
    # LSMinimumSystemVersion in upstream's release bundle (script/package_release.sh)
    (darwinMinVersionHook "26.0")
  ];

  doCheck = true;
  # Foundation reads ICU data to parse URL hosts; without it URLComponents.host is nil in the
  # sandbox (the embedded-server tests). The panel tests create an NSPanel, which loads AppKit's
  # built-in appearance.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
    (allow file-read* (subpath "/System/Library/CoreServices/SystemAppearance.bundle"))
  '';

  # Upstream's CI runs `swift test` in the debug configuration; the tests use Swift Testing. Debug
  # builds would sign the executable with the get-task-allow entitlement through codesign.
  checkPhase = ''
    runHook preCheck
    # The build-script tests compare the script's $HOME with NSHomeDirectory(), which follows
    # CFFIXED_USER_HOME.
    export CFFIXED_USER_HOME=$HOME
    TERM=dumb swift test --disable-sandbox --disable-xctest --disable-get-task-allow-entitlement \
      -j $NIX_BUILD_CORES \
      -Xswiftc -module-cache-path -Xswiftc "$NIX_BUILD_TOP/module-cache"
    runHook postCheck
  '';

  # The bundle as in upstream's release (script/package_release.sh). Standalone Catch starts
  # `goose serve` itself and only looks in Homebrew's paths or GOOSE_BINARY; embedded hosts such
  # as Berd pass their own server in GOOSE_SERVE_URL.
  installPhase = ''
    runHook preInstall

    app=$out/Applications/Catch.app/Contents
    install -Dm755 "$(swiftpmBinPath)/Catch" $app/MacOS/Catch
    cat > $app/Info.plist <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleExecutable</key>
      <string>Catch</string>
      <key>CFBundleIdentifier</key>
      <string>xyz.block.catch</string>
      <key>CFBundleName</key>
      <string>Catch</string>
      <key>CFBundleDisplayName</key>
      <string>Catch</string>
      <key>CFBundleShortVersionString</key>
      <string>${finalAttrs.version}</string>
      <key>CFBundleVersion</key>
      <string>${finalAttrs.version}</string>
      <key>CFBundlePackageType</key>
      <string>APPL</string>
      <key>LSMinimumSystemVersion</key>
      <string>26.0</string>
      <key>LSUIElement</key>
      <true/>
      <key>NSHighResolutionCapable</key>
      <true/>
      <key>NSPrincipalClass</key>
      <string>NSApplication</string>
    </dict>
    </plist>
    EOF

    wrapProgram $app/MacOS/Catch --set-default GOOSE_BINARY ${lib.getExe goose-cli}
    mkdir -p $out/bin
    ln -s $app/MacOS/Catch $out/bin/catch

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "macOS shortcut for finding and starting Goose agent sessions";
    homepage = "https://github.com/block/catch";
    changelog = "https://github.com/block/catch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "catch";
    maintainers = [ lib.maintainers.kleinbem ];
    platforms = lib.platforms.darwin;
  };
})
