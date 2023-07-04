{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, libGLU
, wrapQtAppsHook
}:

stdenv.mkDerivation {
  pname = "flashprint";
  version = "5.6.1";
  src = fetchurl {
    url = "https://en.fss.flashforge.com/10000/software/01e7742d5a721201cd33d4f8c083b63b.deb";
    hash = "sha256-lvK4igv/L1zrqNtqbWtCyZrSZbkY8Ak/Li3NeVAH1YU=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg wrapQtAppsHook ];
  buildInputs = [ libGLU ];

  qtWrapperArgs = [ "--prefix QT_QPA_PLATFORM : xcb" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/* $out/
    mv etc $out/
    ln -s $out/share/FlashPrint5/FlashPrint $out/bin/
    substituteInPlace $out/share/applications/FlashPrint5.desktop \
        --replace 'Exec=/usr/share/FlashPrint5/FlashPrint' 'Exec=FlashPrint'

    runHook postInstall
  '';

  meta = with lib; {
    description = "The 3d printing slicer by Flashforge";
    homepage = "https://www.flashforge.com/download-center/63";
    license = licenses.unfree;
    maintainers = with maintainers; [ annaaurora ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "FlashPrint";
  };
}
