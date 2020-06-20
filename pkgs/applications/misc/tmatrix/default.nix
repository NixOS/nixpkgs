{ stdenv
, lib
, fetchFromGitHub
, cmake
, installShellFiles
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "tmatrix";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "M4444";
    repo = "TMatrix";
    rev = "v${version}";
    sha256 = "1cvgxmdpdzpl8w4z3sh4g5pbd15rd8s1kcspi9v95yf9rydyy69s";
  };

  nativeBuildInputs = [ cmake installShellFiles ];
  buildInputs = [ ncurses ];

  postInstall = ''
    installManPage ../tmatrix.6
  '';

  meta = with lib; {
    description = "Terminal based replica of the digital rain from The Matrix";
    longDescription = ''
      TMatrix is a program that simulates the digital rain form The Matrix.
      It's focused on being the most accurate replica of the digital rain effect
      achievable on a typical terminal, while also being customizable and
      performant.
    '';
    homepage = "https://github.com/M4444/TMatrix";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ infinisil filalex77 ];
  };
}
