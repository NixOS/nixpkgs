{ lib, mkDerivation, cmake, hunspell, pkg-config, qttools, qtbase, qtsvg, qtx11extras
, fetchFromGitHub }:

mkDerivation rec {
  pname = "featherpad";
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "FeatherPad";
    rev = "V${version}";
<<<<<<< HEAD
    sha256 = "sha256-8IT/PxLz6BsLHzY5pM0bTlAO0xvfC7/aI7+Gbw2LyME=";
=======
    sha256 = "sha256-6hu8r38hrQEt0vaO9XA+KaWPuWYcBdydpjEf2V+m5xY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake pkg-config qttools ];
  buildInputs = [ hunspell qtbase qtsvg qtx11extras ];

  meta = with lib; {
    description = "Lightweight Qt5 Plain-Text Editor for Linux";
    homepage = "https://github.com/tsujan/FeatherPad";
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
    license = licenses.gpl3Plus;
  };
}
