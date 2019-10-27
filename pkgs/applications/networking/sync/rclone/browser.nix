{ stdenv, fetchFromGitHub, cmake, qtbase }:

stdenv.mkDerivation rec {
  pname = "rclone-browser";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mmozeiko";
    repo = "RcloneBrowser";
    rev = version;
    sha256 = "1ldradd5c606mfkh46y4mhcvf9kbjhamw0gahksp9w43h5dh3ir7";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Graphical Frontend to Rclone written in Qt";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
