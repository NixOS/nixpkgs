{ lib
, mkDerivation
, fetchFromGitHub
, bash
, cmake
<<<<<<< HEAD
, boost
, xercesc
, xalanc
, qtbase
, qttools
, qtmultimedia
=======
, qtbase
, qttools
, qtmultimedia
, qtwebkit
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qtsvg
}:

mkDerivation rec {
  pname = "brewtarget";
<<<<<<< HEAD
  version = "3.0.5";
=======
  version = "2.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Brewtarget";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-PqaiZ2eLH8+qRRkIolnQClTL9O9EgHMqFH/nUffosV8=";
  };

  nativeBuildInputs = [ cmake boost xercesc xalanc ];
  buildInputs = [ qtbase qttools qtmultimedia qtsvg ];
=======
    sha256 = "14xmm6f8xmvypagx4qdw8q9llzmyi9zzfhnzh4kbbflhjbcr7isz";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase qttools qtmultimedia qtwebkit qtsvg ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
