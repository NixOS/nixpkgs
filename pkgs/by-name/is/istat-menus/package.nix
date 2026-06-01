{
  lib,
  stdenvNoCC,
  fetchurl,
  writeShellApplication,
  curl,
  common-updater-scripts,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "istat-menus";
  version = "7.20";

  src = fetchurl {
    url = "https://cdn.istatmenus.app/files/istatmenus${lib.versions.major finalAttrs.version}/versions/iStatMenus${finalAttrs.version}.zip";
    hash = "sha256-oJApYp7ejtcMrm7CyeohV/euXYkJJ0yCRBW2i5AgcEE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "istatmenus-update-script";
    runtimeInputs = [
      curl
      common-updater-scripts
    ];
    text = ''
      redirect_url="$(curl -s -L -f "https://download.bjango.com/istatmenus${lib.versions.major finalAttrs.version}/" -o /dev/null -w '%{url_effective}')"
      version="''${redirect_url##*/}"; version="''${version#iStatMenus}"; version="''${version%.zip}"
      update-source-version istat-menus "$version"
    '';
  });

  meta = {
    changelog = "https://bjango.com/mac/istatmenus/versionhistory/";
    description = "Set of nine separate and highly configurable menu items that let you know exactly what's going on inside your Mac";
    homepage = "https://bjango.com/mac/istatmenus/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ FlameFlag ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
