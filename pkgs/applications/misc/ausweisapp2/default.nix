{ stdenv, mkDerivation, fetchFromGitHub, cmake, pkgconfig, pcsclite, qtsvg, qttools, qtwebsockets
, qtquickcontrols2, qtgraphicaleffects }:

mkDerivation rec {
  pname = "AusweisApp2";
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "Governikus";
    repo = "AusweisApp2";
    rev = version;
    sha256 = "1vibk3wmn54qr2mwz537hrr959y0r1zabp0gsijhzj2mk68g9pnb";
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
