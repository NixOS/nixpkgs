{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  swiftPackages,
}:

let
  inherit (swiftPackages) stdenv swift;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "space-rabbit";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "tahul";
    repo = "space-rabbit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RGA0/BiMoDnIqD3gr+jxBthny1+BKlVUC6hs7rrApyY=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    swift
  ];

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    # The upstream icon is generated at build time by an AppKit script that
    # needs a graphical session, so it cannot run in the headless sandbox.
    # Remove the icon reference; the app is a menu bar agent (LSUIElement)
    # and needs no bundle icon.
    sed --in-place \
      '/<key>CFBundleIconFile<\/key>/,+1d' \
      App/Info.plist
  '';

  buildPhase = ''
    runHook preBuild

    swiftTarget=${stdenv.hostPlatform.darwinArch}-apple-macosx15.0

    make \
      VERSION=${finalAttrs.version} \
      SWIFT_TARGET="$swiftTarget" \
      spacerabbit verify-macos-min

    swiftc -O -target "$swiftTarget" \
      -o validate-localizations \
      Tools/Localization/Validate.swift
    ./validate-localizations App/Resources App

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app="$out/Applications/Space Rabbit.app"

    mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources" "$out/bin"
    install -Dm755 spacerabbit "$app/Contents/MacOS/spacerabbit"
    cp -R App/Resources/*.lproj "$app/Contents/Resources/"

    substitute App/Info.plist "$app/Contents/Info.plist" \
      --replace-fail "__VERSION__" "${finalAttrs.version}" \
      --replace-fail "__MACOS_MIN__" "15.0"

    printf 'APPL????' > "$app/Contents/PkgInfo"

    # Launch through a wrapper that execs the bundle executable, so
    # `Bundle.main` resolves to the .app. A bare symlink into $out/bin would
    # make `Bundle.main` the bin directory, which has no .lproj resources, so
    # every localized string would fall back to its raw key.
    makeWrapper "$app/Contents/MacOS/spacerabbit" "$out/bin/space-rabbit"

    runHook postInstall
  '';

  meta = {
    description = "Instant space switching on macOS";
    homepage = "https://github.com/tahul/space-rabbit";
    changelog = "https://github.com/tahul/space-rabbit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    mainProgram = "space-rabbit";
    maintainers = with lib.maintainers; [ sheeeng ];
    platforms = lib.platforms.darwin;
  };
})
