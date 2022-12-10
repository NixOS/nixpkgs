{ cmake, lib, mkDerivation, fetchFromGitLab,
  qtmultimedia, qttools, ... }:

mkDerivation rec {
  pname = "tipp10";
  version = "3.2.1";

  src = fetchFromGitLab {
    owner = "tipp10";
    repo = "tipp10";
    rev = "v${version}";
    sha256 = "4cxN2AnvYhZAMuA/qfmdLVICJNk6VCpRnfelbxYRvPg=";
  };

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ qtmultimedia ];

  meta = with lib; {
    description = "Learn and train typing with the ten-finger system";
    homepage = "https://gitlab.com/tipp10/tipp10";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
