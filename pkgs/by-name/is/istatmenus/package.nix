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
  pname = "istatmenus";
  version = "7.02.10";

  src = fetchurl {
    url = "https://cdn.istatmenus.app/files/istatmenus${lib.versions.major finalAttrs.version}/versions/iStatMenus${finalAttrs.version}.zip";
    hash = "sha256-ckYIQsJ0QEsIpXRFo1xioSCOwEL06d0cJrATa1URMIQ=";
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
      update-source-version istatmenus "$version" --file=./pkgs/by-name/is/istatmenus/package.nix
    '';
  });

  meta = {
    changelog = "https://bjango.com/mac/istatmenus/versionhistory/";
    description = "iStat Menus is set of nine separate and highly configurable menu items that let you know exactly what's going on inside your Mac";
    homepage = "https://bjango.com/mac/istatmenus/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
