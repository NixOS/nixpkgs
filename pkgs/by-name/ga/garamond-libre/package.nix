{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "garamond-libre";
  version = "1.4";

  src = fetchzip {
    url = "https://github.com/dbenjaminmiller/garamond-libre/releases/download/${finalAttrs.version}/garamond-libre_${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-cD/JMICtb6MPIUcWs2VOTHnb/05ma0/KKtPyR4oJlIc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/dbenjaminmiller/garamond-libre";
    description = "Garamond Libre font family";
    maintainers = [ ];
    license = lib.licenses.x11;
    platforms = lib.platforms.all;
  };
})
