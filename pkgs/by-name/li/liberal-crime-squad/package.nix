{
  fetchFromGitHub,
  lib,
  stdenv,
  autoreconfHook,
  libiconv,
  ncurses,
  SDL2,
  SDL2_mixer,
}:

stdenv.mkDerivation {
  version = "2016-07-06";
  pname = "liberal-crime-squad";

  src = fetchFromGitHub {
    owner = "Kamal-Sadek";
    repo = "Liberal-Crime-Squad";
    rev = "2ace84ebe4b65b9d4ef67430d5419d57d340f055";
    sha256 = "0mcldn8ivlfyjfx22ygzcbbw3bzl0j6vi3g6jyj8jmcrni61mgmb";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libiconv
    ncurses
    SDL2
    SDL2_mixer
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Humorous politically themed ncurses game";
    longDescription = ''
      Welcome to Liberal Crime Squad! The Conservatives have taken the Executive, Legislative, and Judicial branches of government. Over time, the Liberal laws of this nation will erode and turn the country into a BACKWOODS YET CORPORATE NIGHTMARE. To prevent this from happening, the Liberal Crime Squad was established. The mood of the country is shifting, and we need to turn things around. Go out on the streets and indoctrinate Conservative automatons. That is, let them see their True Liberal Nature. Then arm them and send them forth to Stop Evil.
    '';
    homepage = "https://github.com/Kamal-Sadek/Liberal-Crime-Squad";
    maintainers = [ maintainers.rardiol ];
    mainProgram = "crimesquad";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
