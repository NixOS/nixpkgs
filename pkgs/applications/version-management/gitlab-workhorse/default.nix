{ stdenv, fetchFromGitLab, git, go }:
stdenv.mkDerivation rec {
  name = "gitlab-workhorse-${version}";

  version = "6.0.0";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "0bg6rci69953h6zpdlv7pmjg751i31ykk6vggxb0ir0a6m8i3vn6";
  };

  buildInputs = [ git go ];

  patches = [ ./remove-hardcoded-paths.patch ./deterministic-build.patch ];

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
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.mit;
  };
}
