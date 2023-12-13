{ lib
, mkDerivation
, fetchFromGitHub
, bash
, cmake
, boost
, xercesc
, xalanc
, qtbase
, qttools
, qtmultimedia
, qtsvg
}:

mkDerivation rec {
  pname = "brewtarget";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "Brewtarget";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PqaiZ2eLH8+qRRkIolnQClTL9O9EgHMqFH/nUffosV8=";
  };

  nativeBuildInputs = [ cmake boost xercesc xalanc ];
  buildInputs = [ qtbase qttools qtmultimedia qtsvg ];

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
