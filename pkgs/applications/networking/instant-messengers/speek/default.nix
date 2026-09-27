{ lib
, stdenv
, fetchFromGitHub
, qmake
, pkg-config
, wrapQtAppsHook
, protobuf
}:

stdenv.mkDerivation rec {
  pname = "speek";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Speek-App";
    repo = "Speek";
    rev = "v${version}-release";
    sha256 = "sha256-j3PcWJEJgBuk1bYervdSi1iS+xT5pu/rfFw3QzI+VFs=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    protobuf
  ];

  sourceRoot = "source/src";

  meta = with lib; {
    description = ''
      Privacy focused messenger that doesn't trust anyone with your identity,
      your contact list, or your communications
    '';
    homepage = "https://github.com/Speek-App/Speek";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };

}
