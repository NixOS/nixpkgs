{ stdenv, fetchFromGitLab, git, buildGoPackage }:

buildGoPackage rec {
  pname = "gitlab-workhorse";

  version = "8.10.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "11cfhh48dga5ghfcijb68gbx0nfr5bs3vvp2j1gam9ac37fpvk0x";
  };

  goPackagePath = "gitlab.com/gitlab-org/gitlab-workhorse";
  goDeps = ./deps.nix;
  buildInputs = [ git ];

  makeFlags = [ "PREFIX=$(out)" "VERSION=${version}" "GOCACHE=$(TMPDIR)/go-cache" ];

  # gitlab-workhorse depends on an older version of labkit which
  # contains old, vendored versions of some packages; gitlab-workhorse
  # also explicitly depends on newer versions of these libraries,
  # but buildGoPackage exposes the vendored versions instead,
  # leading to compilation errors. Since the vendored libraries
  # aren't used here anyway, we'll just remove them.
  postConfigure = ''
    rm -r "$NIX_BUILD_TOP/go/src/gitlab.com/gitlab-org/labkit/vendor"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
