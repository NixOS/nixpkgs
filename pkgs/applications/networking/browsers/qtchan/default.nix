{ mkDerivation, lib, fetchFromGitHub, qmake, qtbase }:

mkDerivation rec {
  pname = "qtchan";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner  = "siavash119";
    repo   = "qtchan";
    rev    = "v${version}";
    sha256 = "1x11m1kwqindzc0dkpfifcglsb362impaxs85kgzx50p898sz9ll";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase ];
  qmakeFlags = [ "CONFIG-=app_bundle" ];

  installPhase = ''
    mkdir -p $out/bin
    cp qtchan $out/bin
  '';

  meta = with lib; {
    description = "4chan browser in qt5";
    homepage    = "https://github.com/siavash119/qtchan";
    license     = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
    platforms   = platforms.unix;
  };
}
