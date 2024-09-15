{ lib, mkDerivation, fetchurl, qtbase, qmake }:

mkDerivation rec {
  pname = "confclerk";
  version = "0.7.2";

  src = fetchurl {
    url = "https://www.toastfreeware.priv.at/tarballs/confclerk/confclerk-${version}.tar.gz";
    sha256 = "sha256-GgWvPHcQnQrK9SOC8U9F2P8kuPCn8I2EhoWEEMtKBww=";
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ qmake ];

  postInstall = ''
    mkdir -p $out/bin
    mv $out/confclerk $out/bin/
  '';

  meta = {
    description = "Offline conference schedule viewer";
    mainProgram = "confclerk";
    homepage = "http://www.toastfreeware.priv.at/confclerk";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux;
  };
}
