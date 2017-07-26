{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  name = "madonctl-${version}";
  version = "1.1.0";

  goPackagePath = "github.com/McKael/madonctl";

  src = fetchFromGitHub {
    owner = "McKael";
    repo = "madonctl";
    rev  = "v${version}";
    sha256 = "1dnc1xaafhwhhf5afhb0wc2wbqq0s1r7qzj5k0xzc58my541gadc";
  };

  # How to update:
  # go get -u github.com/McKael/madonctl
  # cd $GOPATH/src/github.com/McKael/madonctl
  # git checkout v<version-number>
  # go2nix save

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "CLI for the Mastodon social network API";
    homepage = https://github.com/McKael/madonctl;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
