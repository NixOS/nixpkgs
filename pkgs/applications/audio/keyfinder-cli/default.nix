{ stdenv, fetchFromGitHub, libav, libkeyfinder }:

stdenv.mkDerivation rec {
  version = "20150125";
  name = "keyfinder-cli-${version}";

  src = fetchFromGitHub {
    repo = "keyfinder-cli";
    owner = "EvanPurkhiser";
    rev = "3a6f598b3661fdba73ada81cd200a6e56c23ddca";
    sha256 = "05k4g9zdzi4q81p8lax9b2j4bcg1bpp04sdbza5i5pfz2fng2cf7";
  };

  meta = with stdenv.lib; {
    description = "Musical key detection for digital audio (command-line tool)";
    longDescription = ''
      This small utility is the automation-oriented DJ's best friend. By making
      use of Ibrahim Sha'ath's high quality libKeyFinder library, it can be
      used to estimate the musical key of many different audio formats.
    '';
    homepage = https://github.com/EvanPurkhiser/keyfinder-cli;
    license = with licenses; gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ libav libkeyfinder ];

  makeFlagsArray = "PREFIX=$(out)";

  enableParallelBuilding = true;
}
