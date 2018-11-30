{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  name = "gitlab-workhorse-${version}";

  version = "7.1.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "1jq28z2kf58wnbv8jkwfx2bm8ki22hpm9ssdy2ymza22gq0zx00g";
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
