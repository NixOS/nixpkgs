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
  version = "1.0";

  src = fetchFromSourcehut {
    owner = "~bitfehler";
    repo = "bfcal";
    rev = "v${version}";
    sha256 = "sha256-2z5ICVEZ55omwcoVWpac/HPwyKF9jDCYO78S9p21VMU=";
  };

  nativeBuildInputs = [
    meson ninja pkg-config wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  postInstall = ''
    mkdir -p $out/bin
    install bfcal $out/bin
  '';

  meta = with lib; {
    description = "Quickly display a calendar";
    homepage = "https://git.sr.ht/~bitfehler/bfcal";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ laalsaas ];
  };
}
