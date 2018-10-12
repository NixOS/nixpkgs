{ stdenv, fetchFromGitLab, git, go }:
stdenv.mkDerivation rec {
  name = "gitlab-workhorse-${version}";

  version = "6.1.1";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "1dwvk86bfsqgkp0mwz71yis3i7aypjf96r3hsjkgpd27hwbjgxbr";
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
