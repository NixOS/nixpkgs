{ mkDerivation, lib, fetchFromGitHub, cmake, qttools, qtbase }:

mkDerivation rec {
  pname = "heimer";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = pname;
    rev = version;
    sha256 = "sha256-i4jgmqRvBX6g6IOitnBnQqWnFY5QoLk6/Cah0wCU8uc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qttools qtbase ];

  meta = with lib; {
    description = "Simple cross-platform mind map and note-taking tool written in Qt";
    homepage = "https://github.com/juzzlin/Heimer";
    license = licenses.gpl3;
    maintainers  = with maintainers; [ dtzWill ];
    platforms = platforms.linux;
  };
}
