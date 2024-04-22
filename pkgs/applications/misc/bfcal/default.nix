{ stdenv
, lib
, fetchFromSourcehut
, meson
, ninja
, pkg-config
, wrapQtAppsHook
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "bfcal";
  version = "1.0.1";

  src = fetchFromSourcehut {
    owner = "~bitfehler";
    repo = "bfcal";
    rev = "v${version}";
    sha256 = "sha256-5xyBU+0XUNFUGgvw7U8YE64zncw6SvPmbJhc1LY2u/g=";
  };

  nativeBuildInputs = [
    meson ninja pkg-config wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  meta = with lib; {
    description = "Quickly display a calendar";
    mainProgram = "bfcal";
    homepage = "https://git.sr.ht/~bitfehler/bfcal";
    license = licenses.gpl3Plus;
    platforms = qtbase.meta.platforms;
    maintainers = with maintainers; [ laalsaas ];
  };
}
