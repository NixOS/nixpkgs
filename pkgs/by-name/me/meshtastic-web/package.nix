{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "meshtastic-web";
  version = "2.6.7";

  src = fetchurl {
    url = "https://github.com/meshtastic/web/releases/download/v${finalAttrs.version}/build.tar";
    hash = "sha256-o09DYKBIZUOmmN4g3lM1V0kudjq0Wfwn/OqV0ElRRO0=";
  };

  sourceRoot = ".";

  buildPhase = ''
    runHook preBuild

    gzip -dr .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -ar . $out/

    runHook postInstall
  '';

  meta = {
    description = "Meshtastic Web Client/JS Monorepo";
    homepage = "https://github.com/meshtastic/web";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
