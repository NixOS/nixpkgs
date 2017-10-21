{ stdenv, fetchFromGitHub, libav, libkeyfinder }:

stdenv.mkDerivation rec {
  name = "keyfinder-cli-${version}";
  version = "2015-09-13";

  src = fetchFromGitHub {
    repo = "keyfinder-cli";
    owner = "EvanPurkhiser";
    rev = "8579282f15ab3ebad937fed398ec5c88843be03d";
    sha256 = "0jylykigxmsqvdny265k58vpxa4cqs1hq2f7mph1nl3apfx2shrh";
  };

  buildInputs = [ libav libkeyfinder ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Musical key detection for digital audio (command-line tool)";
    longDescription = ''
      This small utility is the automation-oriented DJ's best friend. By making
      use of Ibrahim Sha'ath's high quality libKeyFinder library, it can be
      used to estimate the musical key of many different audio formats.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
