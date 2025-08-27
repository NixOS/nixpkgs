{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "garamond-libre";
  version = "1.4";

  src = fetchzip {
    url = "https://github.com/dbenjaminmiller/garamond-libre/releases/download/${version}/garamond-libre_${version}.zip";
    stripRoot = false;
    hash = "sha256-cD/JMICtb6MPIUcWs2VOTHnb/05ma0/KKtPyR4oJlIc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dbenjaminmiller/garamond-libre";
    description = "Garamond Libre font family";
    maintainers = with maintainers; [ ];
    license = licenses.x11;
    platforms = platforms.all;
  };
}
