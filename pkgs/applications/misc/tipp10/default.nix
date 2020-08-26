{ cmake, stdenv, mkDerivation, fetchFromGitLab,
  qtmultimedia, qttools, ... }:

mkDerivation rec {
  pname = "tipp10";
  version = "3.2.0";

  src = fetchFromGitLab {
    owner = "tipp10";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fav5jlw6lw78iqrj7a65b8vd50hhyyaqyzmfrvyxirpsqhjk1v7";
  };

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ qtmultimedia ];

  meta = with stdenv.lib; {
    description = "Learn and train typing with the ten-finger system";
    homepage = "https://gitlab.com/a_a/tipp10";
    license = licenses.gpl2;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
  };
}
