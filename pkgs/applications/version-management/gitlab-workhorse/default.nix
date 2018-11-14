{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  name = "gitlab-workhorse-${version}";

  version = "7.0.0";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "1mmfb7h5sbva2kv9h9cxfg7dyksxrwwikq7jwggfawqaadzwm677";
  };

  buildInputs = [ git go ];

  patches = [ ./remove-hardcoded-paths.patch ./deterministic-build.patch ];

  makeFlags = [ "PREFIX=$(out)" "VERSION=${version}" ];

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.mit;
  };
}
