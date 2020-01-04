{ stdenv, fetchFromGitLab, git, buildGoPackage }:

buildGoPackage rec {
  pname = "gitlab-workhorse";

  version = "8.18.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "0qsbz8gv9r9wfvxsh9mpspgs2gyyidxdz5n9n7ibfy7z129mx4ak";
  };

  goPackagePath = "gitlab.com/gitlab-org/gitlab-workhorse";
  goDeps = ./deps.nix;
  buildInputs = [ git ];
  buildFlagsArray = "-ldflags=-X main.Version=${version}";

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
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
