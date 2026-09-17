{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "linear";
  version = "1.31.1";

  src = fetchurl {
    url = "https://releases.linear.app/Linear-${finalAttrs.version}-universal.dmg";
    hash = "sha256-haZz9RdbcQiFbCqdy/S25aCsFoSKn3dFAkYL8NgoTYw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = "Linear";

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
    maintainers = with lib.maintainers; [
      wini
      pradyuman
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
