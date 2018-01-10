{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  version = "3.3.1";
  name = "gitlab-workhorse-${version}";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "19x9ryp99xygj39kq2r756rahh9mxp6j83hxvv09y33vgz64y8xh";
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
