{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "deskreen";
  version = "2.0.4";

  src = fetchurl {
    url = "https://github.com/pavlobu/deskreen/releases/download/v${finalAttrs.version}/Deskreen-${finalAttrs.version}.AppImage";
    hash = "sha256-0jI/mbXaXanY6ay2zn+dPWGvsqWRcF8aYHRvfGVsObE=";
  };
  deskreenUnwrapped = appimageTools.wrapType2 {
    name = "deskreen";
    src = finalAttrs.src;
  };

  buildInputs = [
    finalAttrs.deskreenUnwrapped
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${finalAttrs.deskreenUnwrapped}/bin/deskreen $out/bin/deskreen

    runHook postInstall
  '';

  meta = {
    description = "Turn any device into a secondary screen for your computer";
    homepage = "https://deskreen.com";
    license = lib.licenses.agpl3Only;
    mainProgram = "deskreen";
    maintainers = with lib.maintainers; [
      leo248
      drupol
    ];
    platforms = lib.platforms.linux;
  };
})
