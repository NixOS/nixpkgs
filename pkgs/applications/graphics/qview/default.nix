{ mkDerivation, lib, fetchFromGitHub, qmake, qtbase }:

mkDerivation rec {
  pname = "qview";
  version = "2.0";
  src = fetchFromGitHub {
    owner = "jurplel";
    repo = "qView";
    rev = version;
    sha256 = "1s29hz44rb5dwzq8d4i4bfg77dr0v3ywpvidpa6xzg7hnnv3mhi5";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    qtbase
  ];

  patchPhase = ''
    sed "s|/usr/|$out/|g" -i qView.pro
  '';

  meta = with lib; {
    description = "Practical and minimal image viewer";
    homepage = "https://interversehq.com/qview/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
