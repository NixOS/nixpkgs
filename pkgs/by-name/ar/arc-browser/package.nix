{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  writeShellApplication,
  curl,
  common-updater-scripts,
  xmlstarlet,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arc-browser";
  version = "1.109.0-67185";

  src = fetchurl {
    url = "https://releases.arc.net/release/Arc-${finalAttrs.version}.dmg";
    hash = "sha256-zVErRSKMd5xhIB5fyawBNEatenHnm+q7VLAE78PLkmY=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Arc.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Arc.app"
    cp -R . "$out/Applications/Arc.app"

    runHook postInstall
  '';

  dontFixup = true;

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "arc-browser-update-script";
    runtimeInputs = [
      curl
      common-updater-scripts
      xmlstarlet
    ];
    text = ''
      latest_version_string="$(curl -s "https://releases.arc.net/updates.xml" | xmlstarlet sel -N sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" -t -v "//item[1]/sparkle:shortVersionString" -n)"
      version_part="''${latest_version_string%% (*}"
      build_part="''${latest_version_string##*\(}"
      build_part="''${build_part%\)*}"
      version="''${version_part}-''${build_part}"

      update-source-version arc-browser "$version"
    '';
  });

  meta = {
    description = "Arc from The Browser Company";
    homepage = "https://arc.net/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
    knownVulnerabilities = [ "unmaintained" ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
