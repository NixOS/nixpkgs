{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools }:

mkDerivation rec {
  pname = "tiled";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jfr9ngsbkn9j3yvy3mnx0llfwmk39dj8kfiy9fawkhw0v4bzjbd";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ python qtbase qttools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, easy to use and flexible tile map editor";
    homepage = https://www.mapeditor.org/;
    license = with licenses; [
      bsd2	# libtiled and tmxviewer
      gpl2Plus	# all the rest
    ];
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
