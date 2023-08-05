{ lib
, stdenv
, fetchFromGitHub
, cmake
, magic-enum
, spdlog
, qtbase
, qtconnectivity
, qttools
, qtlanguageserver
, wrapQtAppsHook
, libXScrnSaver
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "kemai";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "AlexandrePTJ";
    repo = "kemai";
    rev = version;
    hash = "sha256-PDjNO2iMPK0J3TSHVZ/DW3W0GkdB8yNZYoTGEd2snac=";
  };

  buildInputs = [
    qtbase
    qtconnectivity
    qttools
    qtlanguageserver
    libXScrnSaver
    magic-enum
    spdlog
  ];
  cmakeFlags = [ "-DUSE_CONAN=OFF" ];
  patches = [ ./000-cmake-disable-conan.diff ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Kimai desktop client written in QT6";
    homepage = "https://github.com/AlexandrePTJ/kemai";
    license = licenses.mit;
    maintainers = with maintainers; [ poelzi ];
    platforms   = platforms.unix;
  };
}
