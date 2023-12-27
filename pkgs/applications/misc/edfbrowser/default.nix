{ lib, stdenv, fetchFromGitLab, qmake, qtbase, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "edfbrowser";
  version = "2.05";

  src = fetchFromGitLab {
    owner = "Teuniz";
    repo = "EDFbrowser";
    rev = "v${version}";
    sha256 = "sha256-ISJAWqsBYm65fiv9ju0TD2idUkmwpq21M50rNhOk5ys=";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];
  cmakeDir = "EDFbrowser";
  buildInputs = [ qtbase ];

  prePatch = ''
    substituteInPlace edfbrowser.pro --replace "/usr" "$out"
  '';

  meta = with lib; {
    description = "EDF+ and BDF+ viewer and toolbox";
    homepage = "https://gitlab.com/Teuniz/EDFbrowser";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ziguana ];
    mainProgram = "edfbrowser";
  };
}
