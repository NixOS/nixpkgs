{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  name = "gitlab-workhorse-${version}";

  version = "8.7.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "1zlngc498hnzbxwdjn3ymr0xwrnfgnzzhn9lyf37yfbjl8x28n3z";
  };

  buildInputs = [ git go ];

  makeFlags = [ "PREFIX=$(out)" "VERSION=${version}" "GOCACHE=$(TMPDIR)/go-cache" ];

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.mit;
  };
}
