{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  version = "0.8.5";
  name = "gitlab-workhorse-${version}";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "0q6kd59sb5wm63r8zdvbkn4j6fk2n743pjhkbmg4rzngvjivxqzr";
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
