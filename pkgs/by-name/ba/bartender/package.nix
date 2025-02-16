{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  curl,
  cacert,
  xmlstarlet,
  writeShellApplication,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bartender";
  version = "5.2.7";

  src = fetchurl {
    name = "Bartender ${lib.versions.major finalAttrs.version}.dmg";
    url = "https://www.macbartender.com/B2/updates/${
      builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }/Bartender%20${lib.versions.major finalAttrs.version}.dmg";
    hash = "sha256-TY6ioG80W8q6LC0FCMRQMJh4DiEKiM6htVf+irvmpnI=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = "Bartender ${lib.versions.major finalAttrs.version}.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/${finalAttrs.sourceRoot}"
    cp -R . "$out/Applications/${finalAttrs.sourceRoot}"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "bartender-update-script";
    runtimeInputs = [
      curl
      cacert
      xmlstarlet
      common-updater-scripts
    ];
    text = ''
      version_major="${lib.versions.major finalAttrs.version}"
      url="https://www.macbartender.com/B2/updates/AppcastB$version_major.xml"
      version=$(curl -s "$url" | xmlstarlet sel -t -v '(//item)[last()]/sparkle:shortVersionString' -n)
      update-source-version bartender "$version"
    '';
  });

  meta = {
    description = "Take control of your menu bar";
    longDescription = ''
      Bartender is an award-winning app for macOS that superpowers your menu bar, giving you total control over your menu bar items, what's displayed, and when, with menu bar items only showing when you need them.
      Bartender improves your workflow with quick reveal, search, custom hotkeys and triggers, and lots more.
    '';
    homepage = "https://www.macbartender.com";
    changelog = "https://macbartender.com/B2/updates/${
      builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }/rnotes.html";
    license = [ lib.licenses.unfree ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      stepbrobd
      DimitarNestorov
    ];
    platforms = lib.platforms.darwin;
  };
})
