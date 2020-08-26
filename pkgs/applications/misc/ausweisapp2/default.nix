{ stdenv, mkDerivation, fetchFromGitHub, cmake, pkgconfig, pcsclite, qtsvg, qttools, qtwebsockets
, qtquickcontrols2, qtgraphicaleffects }:

mkDerivation rec {
  pname = "AusweisApp2";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "Governikus";
    repo = "AusweisApp2";
    rev = "${version}";
    sha256 = "17ify6v4z8i8ps3s8qabnrqfkj0my4yzyqwk3q3nhrqilbnhr40x";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qtsvg qttools qtwebsockets qtquickcontrols2 qtgraphicaleffects pcsclite ];

  meta = with stdenv.lib; {
    description = "Authentication software for the German ID card";
    downloadPage = "https://github.com/Governikus/AusweisApp2/releases";
    homepage = "https://www.ausweisapp.bund.de/ausweisapp2/";
    license = licenses.eupl12;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = platforms.linux;
  };
}
