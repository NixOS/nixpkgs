{
  stdenvNoCC,
  fetchurl,
  lib,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "instantview";
  version = "3.24R0004";

  src = fetchurl {
    url = "https://www.siliconmotion.com/downloads/macOS_InstantView_V${finalAttrs.version}.dmg";
    hash = "sha256-lozVykKK1edUQlwxNKy/GyMKjsQaXeR9XVoau72Bwhg=";
  };

  nativeBuildInputs = [ _7zz ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"

    # Extract the DMG using 7zip
    7zz x "$src" -oextracted -y

    cp -r extracted/*.app "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    platforms = lib.platforms.darwin;
    description = "USB Docking Station plugin-and-display support with SM76x driver";
    homepage = "https://www.siliconmotion.com/events/instantview/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ aspauldingcode ];
  };
})
