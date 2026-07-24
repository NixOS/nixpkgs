{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook3
, gtk3
, webkitgtk_4_1
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chronicler";
  version = "0.56.3-alpha";

  src = fetchurl {
    url = "https://github.com/mak-kirkland/chronicler/releases/download/v${finalAttrs.version}/Chronicler_${lib.head (lib.splitString "-" finalAttrs.version)}_amd64.deb";
    hash = "sha256-0MEh1Zp2hmfBZI2WcpNh58AHOnmLexteIVSllmzefnM=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/* $out/
    runHook postInstall
  '';

  meta = {
    description = "A free, offline worldbuilding tool and local wiki for writers and RPG creators";
    homepage = "https://chronicler.pro/";
    license = lib.licenses.polyFormShield100;
    maintainers = with lib.maintainers; [ enderfare frozenoverthemoon ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "chronicler";
  };
})
