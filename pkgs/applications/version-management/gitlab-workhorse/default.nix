{ stdenv, fetchFromGitLab, git, go }:
stdenv.mkDerivation rec {
  name = "gitlab-workhorse-${version}";

  version = "6.1.0";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "0h0mqalia4ldb2icr2h6x75pnr5jb5y23pi4kv4ri3w3ddnl74bq";
  };

  buildInputs = [ git go ];

  patches = [ ./remove-hardcoded-paths.patch ];

  makeFlags = [ "PREFIX=$(out)" "VERSION=${version}" ];

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.mit;
  };
}
