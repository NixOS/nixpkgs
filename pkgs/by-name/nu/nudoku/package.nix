{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  autoreconfHook,
  pkg-config,
  gettext,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "nudoku";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "jubalh";
    repo = "nudoku";
    rev = version;
    hash = "sha256-aOtP23kNd15DdV6on7o80QnEf0CiUBubHfFE8M1mhg0=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/jubalh/nudoku/commit/c5fd9156d2d1f2c95a5d87b07adeaee90a7f911d.patch?full_index=1";
      hash = "sha256-nvLKAUCDY3fQWjybVX8DaMBdk5CaegRRb/ENTI9kJ9k=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
  ];
  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Ncurses based sudoku game";
    mainProgram = "nudoku";
    homepage = "https://jubalh.github.io/nudoku";
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = platforms.all;
    maintainers = with maintainers; [ weathercold ];
  };
}
