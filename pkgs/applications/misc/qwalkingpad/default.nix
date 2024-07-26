{ stdenv
, lib
, qtbase
, qtconnectivity
, wrapQtAppsHook
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "qwalkingpad";
  version = "0.1-git.556bca7";

  src = fetchFromGitHub {
    owner = "DorianRudolph";
    repo = "QWalkingPad";
    rev = "556bca7e610c863aab33f9b8d66f98b574272fac";
    sha256 = "neMr94MyVrnKs+W2jh3YqBw/7tCa58hk14df/w/aDRg=";
    fetchSubmodules = true;
  };

  buildInputs = [ qtbase qtconnectivity ];
  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  installPhase = ''
    install -D /build/source/build/qwalkinkpad2 "$out/bin/qwalkingpad"
  '';

  meta = with lib; {
    description = "Desktop Application for the Kingsmith WalkingPad";
    homepage = "https://github.com/DorianRudolph/QWalkingPad";
    license = licenses.gpl3;
    maintainers = with maintainers; [ avaq ];
    platforms = platforms.unix;
  };
}
