{ stdenv, lib, fetchFromGitHub, cmake, ncurses }:

stdenv.mkDerivation rec {
  pname = "tmatrix";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "M4444";
    repo = "TMatrix";
    rev = "v${version}";
    sha256 = "1x9drk3wdsd6vzcypk3x068sqcbgis488s9fhcpsv8xgb496rd6y";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses ];

  postInstall = ''
    mkdir -p $out/share/man/man6
    install -m 0644 ../tmatrix.6 $out/share/man/man6
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
    maintainers = with maintainers; [ infinisil ];
  };
}
