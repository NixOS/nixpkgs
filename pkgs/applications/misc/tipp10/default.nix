{ cmake, stdenv, mkDerivation, fetchFromGitLab,
  qtmultimedia, qttools, ... }:

mkDerivation rec {
  pname = "tipp10-unstable";
  version = "2020-06-16";

  src = fetchFromGitLab {
    owner = "tipp10";
    repo = "tipp10";
    rev = "2dd6d45c8a91cff7075675d8875721456cdd5f1b";
    sha256 = "16x51rv4r6cz5vsmrfbakqzbfxy456h82ibzacknp35f41cjdqq4";
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
