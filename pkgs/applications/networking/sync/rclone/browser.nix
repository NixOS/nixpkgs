{ stdenv, fetchFromGitHub, qt5,cmake  }:

stdenv.mkDerivation rec {
  name = "rclone-browser-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mmozeiko";
    repo = "RcloneBrowser";
    rev = "${version}";
    sha256 = "1ldradd5c606mfkh46y4mhcvf9kbjhamw0gahksp9w43h5dh3ir7";
  };
  
  buildInputs = [ qt5.qtbase cmake ];
  meta = with stdenv.lib; {
    description = "Graphical Frontend to Rclone written in Qt";
    homepage = https://github.com/mmozeiko/RcloneBrowser;
    license = licenses.unlicense;
    platforms = platforms.linux;
  };
}
