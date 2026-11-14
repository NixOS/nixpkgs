{
  lib,
  stdenvNoCC,
  fetchurl,
  jre,
  copyDesktopItems,
  makeBinaryWrapper,
  makeShellWrapper,
  makeDesktopItem,
  unzip,
  zip,
  chromium,

  # Either "community" or "pro"
  iconName ? "community",
  licenseAccepted ? false,
  javaArgs ? [ ],
  burpArgs ? [ ],
}:
let
  chromiumPlatform =
    {
      "x86_64-linux" = "linux64";
      "aarch64-linux" = "linuxarm64";
    }
    .${stdenvNoCC.hostPlatform.system} or null;
in
assert lib.assertMsg (
  iconName == "pro" || iconName == "community"
) "iconName has to be either pro or community";

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "burpsuite";
  version = "2026.10.1";

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger-cdn.net/burp/releases/download?product=desktop&version=${finalAttrs.version}&type=Jar"
      "https://portswigger.net/burp/releases/download?product=desktop&version=${finalAttrs.version}&type=Jar"
      "https://web.archive.org/web/https://portswigger.net/burp/releases/download?product=desktop&version=${finalAttrs.version}&type=Jar"
    ];
    hash = "sha256-6KsIZTexZDuRygnS/CpsPgiouuDIUoB5fFyex2UGw8U=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    makeShellWrapper
    unzip
    zip
  ];

  unpackPhase = ''
    runHook preUnpack

    install $src ${finalAttrs.src.name}

    runHook postUnpack
  '';

  buildPhase = lib.optionalString (chromiumPlatform != null) ''
    runHook preBuild

    # Replace the embedded Chromium with the nixpkgs one on Linux
    chromiumVersion=$(
      unzip -p ${finalAttrs.src.name} chromium.properties |
        grep "^${chromiumPlatform}=" |
        cut -d= -f2
    )

    archive=chromium-${chromiumPlatform}-$chromiumVersion.zip

    mkdir chromium

    # We need to use a binary wrapper, as burpsuite checks the file for ELF magic bytes
    makeBinaryWrapper \
      ${lib.getExe chromium} \
      chromium/chrome

    # Generate the values for the manifest.properties file
    size=$(stat -Lc %s chromium/chrome)
    md5=$(md5sum chromium/chrome | cut -d' ' -f1)

    echo "chrome:$size;$md5;exe;False;null" > chromium/manifest.properties

    # Normalize timestamps of the generated files before zipping for reproducibility
    touch -d @$SOURCE_DATE_EPOCH chromium/chrome chromium/manifest.properties

    (
      cd chromium
      zip -0 -X -o -q ../"$archive" chrome manifest.properties
    )

    zip -X -q -d ${finalAttrs.src.name} "$archive"
    zip -0 -X -q ${finalAttrs.src.name} "$archive"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 ${finalAttrs.src.name} "$out/share/${finalAttrs.src.name}"

    makeShellWrapper ${lib.getExe jre} "$out/bin/burpsuite" \
      --add-flags "${lib.concatStringsSep " " javaArgs}" \
      --add-flags "-jar $out/share/${finalAttrs.src.name}" \
      --add-flags "--suppress-jre-check --disable-check-for-updates-dialog --disable-auto-update" \
      --add-flags "${lib.optionalString licenseAccepted "--i-accept-the-license-agreement"}" \
      --add-flags "${lib.concatStringsSep " " burpArgs}"

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p "$out/share/icons/hicolor/64x64/apps"
    unzip -p ${finalAttrs.src} resources/Media/icon64${iconName}.png > "$out/share/icons/hicolor/64x64/apps/burpsuite.png"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = "burpsuite";
      icon = "burpsuite";
      desktopName = "Burp Suite Desktop";
      comment = finalAttrs.meta.description;
      categories = [
        "Development"
        "Security"
        "System"
      ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Integrated platform for performing security testing of web applications";
    longDescription = ''
      Burp Suite is an integrated platform for performing security testing of web applications.
      Its various tools work seamlessly together to support the entire testing process, from
      initial mapping and analysis of an application's attack surface, through to finding and
      exploiting security vulnerabilities.
    '';
    homepage = "https://portswigger.net/burp/";
    changelog = "https://portswigger.net/burp/releases/professional-community-${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.unfree;
    platforms = jre.meta.platforms;
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [
      bennofs
      blackzeshi
      fab
      yechielw
      letgamer
    ];
    mainProgram = "burpsuite";
  };
})
