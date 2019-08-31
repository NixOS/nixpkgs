{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  pname = "gitlab-workhorse";

  version = "8.8.1";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "02a1z2nky31acd17q2n4pi4jkbkr6x6frfi6qlcsmfza0x0kzpc0";
  };

  buildInputs = [ git go ];

  makeFlags = [ "PREFIX=$(out)" "VERSION=${version}" "GOCACHE=$(TMPDIR)/go-cache" ];

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.mit;
  };
}
