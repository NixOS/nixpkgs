{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  version = "0.21.2";
  name = "gitaly-${version}";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "025r6vcra2bjm6xggcgnsqgkpvd7y2w73ff6lxrn06lbr4dfbfrf";
  };

  buildInputs = [ git go ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/bin
    make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ roblabla ];
    license = licenses.mit;
  };
}
