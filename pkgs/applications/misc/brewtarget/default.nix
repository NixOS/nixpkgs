{ lib
, mkDerivation
, fetchFromGitHub
, bash
, boost
, cmake
, qtbase
, qttools
, qtmultimedia
, qtsvg
, xalanc
, xercesc
}:

mkDerivation rec {
  pname = "brewtarget";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "Brewtarget";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qgwzRjRVEk8hM1CmkoWrJT285RQnk5zq16dfSijai1Q=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost qtbase qttools qtmultimedia qtsvg xalanc xercesc ];

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
