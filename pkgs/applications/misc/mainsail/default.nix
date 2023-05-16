{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "mainsail";
<<<<<<< HEAD
  version = "2.7.1";

  src = fetchzip {
    url = "https://github.com/mainsail-crew/mainsail/releases/download/v${version}/mainsail.zip";
    hash = "sha256-j2ri7PyQGzRlhpgE9qKneX00HwlDmIi2JUremz446wk=";
=======
  version = "2.5.1";

  src = fetchzip {
    url = "https://github.com/mainsail-crew/mainsail/releases/download/v${version}/mainsail.zip";
    hash = "sha256-xdmi1Q2j2gG4ajh57mBsjH3qCBwpsZCQbh0INFKifg4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
