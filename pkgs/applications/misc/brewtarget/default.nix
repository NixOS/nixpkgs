{ lib
, stdenv
, fetchFromGitHub
, bash
, boost
, cmake
, qt5
, xalanc
, xercesc
}:

stdenv.mkDerivation rec {
  pname = "brewtarget";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "Brewtarget";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qgwzRjRVEk8hM1CmkoWrJT285RQnk5zq16dfSijai1Q=";
  };

  nativeBuildInputs = [ cmake qt5.wrapQtAppsHook ];
  buildInputs = [ boost xalanc xercesc ] ++
    (with qt5; [ qtbase qttools qtmultimedia qtsvg xalanc xercesc ]);

  preConfigure = ''
    chmod +x configure
    substituteInPlace configure --replace /bin/bash "${bash}/bin/bash"
  '';

  meta = with lib; {
    description = "Open source beer recipe creation tool";
    homepage = "http://www.brewtarget.org/";
    license = licenses.gpl3;
    maintainers = [ maintainers.mmahut ];
  };
}
