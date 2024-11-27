{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "nudoku";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jubalh";
    repo = pname;
    rev = version;
    sha256 = "12v00z3p0ymi8f3w4b4bgl4c76irawn3kmd147r0ap6s9ssx2q6m";
  };

  patches = [
    # Pull upstream fix for ncurses-6.3
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/jubalh/nudoku/commit/93899a0fd72e04b9f257e5f54af53466106b5959.patch";
      sha256 = "1h3za0dnx8fk3vshql5mhcici8aw8j0vr7ra81p3r1rii4c479lm";
    })
  ];

  # Allow gettext 0.20
  postPatch = ''
    substituteInPlace configure.ac --replace 0.19 0.20
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config gettext ];
  buildInputs = [ ncurses ];

  configureFlags = lib.optional stdenv.hostPlatform.isMusl "--disable-nls";

  meta = with lib; {
    description = "Ncurses based sudoku game";
    mainProgram = "nudoku";
    homepage = "http://jubalh.github.io/nudoku/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ ];
  };
}

