{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  name = "gitlab-workhorse-${version}";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "1z4iyymld3pssf1dwar0hy6c5hii79gk4k59mqj0mgy2k73405y0";
  };

  buildInputs = [ git go ];

  patches = [ ./remove-hardcoded-paths.patch ];

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
    maintainers = with maintainers; [ fpletz ];
    license = licenses.mit;
  };
}
