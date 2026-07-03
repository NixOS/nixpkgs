{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "linear";
  version = "1.30.2";

  src = fetchurl {
    url = "https://releases.linear.app/Linear-${finalAttrs.version}-universal.dmg";
    hash = "sha256-udtN7sOnbT1B684q/JhPFGq8mYvhc5CbTxuJi6NYFac=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = "Linear";

  # -snld prevents "ERROR: Dangerous symbolic link path was ignored".
  # -xr'!*:com.apple.*' prevents macOS extended attributes from being
  # extracted as regular files, which corrupts the .app bundle.
  unpackCmd = "7zz x -snld -xr'!*:com.apple.*' $curSrc";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Linear.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "App to manage software development and track bugs";
    homepage = "https://linear.app/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ iniw ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
