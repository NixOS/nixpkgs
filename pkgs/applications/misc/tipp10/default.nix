{ cmake, stdenv, mkDerivation, fetchFromGitLab,
  qtmultimedia, qttools, ... }:

mkDerivation rec {
  pname = "tipp10";
  version = "3.1.0";

  src = fetchFromGitLab {
    owner = "a_a";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mksga1zyqz1y2s524nkw86irg36zpjwz7ff87n2ygrlysczvnx1";
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
