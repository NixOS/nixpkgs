{ stdenv, fetchpatch, fetchFromGitHub, which, git, ronn, perl, ShellCommand, TestMost }:

stdenv.mkDerivation rec {
  version = "1.20170226";       # date of commit we're pulling
  name = "vcsh-${version}";

  src = fetchFromGitHub {
    owner = "RichiH";
    repo = "vcsh";
    rev = "36a7cedf196793a6d99f9d3ba2e69805cfff23ab";
    sha256 = "16lb28m4k7n796cc1kifyc1ixry4bg69q9wqivjzygdsb77awgln";
  };

  patches =
    [
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/RichiH/vcsh/pull/222.patch";
        sha256 = "0grdbiwq04x5qj0a1yd9a78g5v28dxhwl6mwxvgvvmzs6k5wnl3k";
      })
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/RichiH/vcsh/pull/228.patch";
        sha256 = "0sdn4mzrhaynw85knia2iw5b6rgy0l1rd6dwh0lwspnh668wqgam";
      })
    ];

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
