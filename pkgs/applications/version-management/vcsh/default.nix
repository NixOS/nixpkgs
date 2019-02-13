{ stdenv, fetchFromGitHub, which, git, ronn, perlPackages }:

stdenv.mkDerivation rec {
  version = "1.20170915";       # date of commit we're pulling
  name = "vcsh-${version}";

  src = fetchFromGitHub {
    owner = "RichiH";
    repo = "vcsh";
    rev = "eadb8df6aa71a76e5be36492edcadb118bd862ac";
    sha256 = "1wfzp8167lcq6akdpbi8fikjv0z3h1i5minh3423dljc04q0klm1";
  };

  buildInputs = [ which git ronn ]
    ++ (with perlPackages; [ perl ShellCommand TestMost TestDifferences TestDeep TestException TestWarn ]);

  installPhase = "make install PREFIX=$out";

  meta = with stdenv.lib; {
    description = "Version Control System for $HOME";
    homepage = https://github.com/RichiH/vcsh;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ garbas ttuegel ];
    platforms = platforms.unix;
  };
}
