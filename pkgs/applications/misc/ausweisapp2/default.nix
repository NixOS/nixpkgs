{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config, pcsclite, qtsvg, qttools, qtwebsockets
, qtquickcontrols2, qtgraphicaleffects }:

mkDerivation rec {
  pname = "AusweisApp2";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "Governikus";
    repo = "AusweisApp2";
    rev = version;
    sha256 = "sha256-Uoi12odfJGyNc8Ap7E/zm4xklYdPPQvCGNxjb9AWJOI=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ qtsvg qttools qtwebsockets qtquickcontrols2 qtgraphicaleffects pcsclite ];

  meta = with lib; {
    description = "Authentication software for the German ID card";
    downloadPage = "https://github.com/Governikus/AusweisApp2/releases";
    homepage = "https://www.ausweisapp.bund.de/ausweisapp2/";
    license = licenses.eupl12;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = platforms.linux;
  };
}
