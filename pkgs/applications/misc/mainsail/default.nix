{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "mainsail";
  version = "2.6.0";

  src = fetchzip {
    url = "https://github.com/mainsail-crew/mainsail/releases/download/v${version}/mainsail.zip";
    hash = "sha256-zTlM02brIiXWKkRQ4zW+BEp+66iCelNsd+uN6yWfqYM=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mainsail
    cp -r ./* $out/share/mainsail

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web interface for managing and controlling 3D printers with Klipper";
    homepage = "https://docs.mainsail.xyz";
    changelog = "https://github.com/mainsail-crew/mainsail/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ shhht lovesegfault ];
  };
}
