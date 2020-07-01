{ lib
, mkDerivation
, fetchFromGitHub
, bash
, cmake
, qtbase
, qttools
, qtmultimedia
, qtwebkit
, qtsvg
}:

mkDerivation rec {
  pname = "brewtarget";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Brewtarget";
    repo = pname;
    rev = "v${version}";
    sha256 = "14xmm6f8xmvypagx4qdw8q9llzmyi9zzfhnzh4kbbflhjbcr7isz";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase qttools qtmultimedia qtwebkit qtsvg ];

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
