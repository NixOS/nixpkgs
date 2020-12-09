{ mkDerivation, lib, fetchFromGitHub, alsaLib, pkgconfig, qtbase, qtscript, qmake
}:

mkDerivation rec {
  pname = "iannix";
  version = "0.9.20-b";

  src = fetchFromGitHub {
    owner = "iannix";
    repo = "IanniX";
    rev = "v${version}";
    sha256 = "6jjgMvD2VkR3ztU5LguqhtNd+4/ZqRy5pVW5xQ6K20Q=";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ alsaLib qtbase qtscript ];

  qmakeFlags = [ "PREFIX=/" ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Graphical open-source sequencer";
    homepage = "https://www.iannix.org/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ freezeboy ];
  };
}
