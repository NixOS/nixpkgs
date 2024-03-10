{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "mainsail";
  version = "2.10.0";

  src = fetchzip {
    url = "https://github.com/mainsail-crew/mainsail/releases/download/v${version}/mainsail.zip";
    hash = "sha256-5bRmM/BXI0Afe7UK6avh5aWFXkYF4MsUG71uYUc5JlA=";
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
