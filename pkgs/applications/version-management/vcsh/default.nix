{ stdenv, fetchFromGitHub, which, git, ronn, perl, ShellCommand, TestMost }:

stdenv.mkDerivation rec {
  version = "1.20170226";       # date of commit we're pulling
  name = "vcsh-${version}";

  src = fetchFromGitHub {
    owner = "RichiH";
    repo = "vcsh";
    rev = "36a7cedf196793a6d99f9d3ba2e69805cfff23ab";
    sha256 = "16lb28m4k7n796cc1kifyc1ixry4bg69q9wqivjzygdsb77awgln";
  };

  buildInputs = [ which git ronn perl ShellCommand TestMost ];

  installPhase = "make install PREFIX=$out";

  meta = with stdenv.lib; {
    description = "Version Control System for $HOME";
    homepage = https://github.com/RichiH/vcsh;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ garbas ttuegel ];
    platforms = platforms.unix;
  };
}
