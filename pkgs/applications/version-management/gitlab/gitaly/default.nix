{ stdenv, fetchFromGitLab, fetchFromGitHub, buildGoPackage, ruby,
  bundlerEnv, pkgconfig, libgit2 }:

let
  rubyEnv = bundlerEnv rec {
    name = "gitaly-env";
    inherit ruby;
    copyGemFiles = true;
    gemdir = ./.;
    gemset =
      let x = import (gemdir + "/gemset.nix");
      in x // {
        # grpc expects the AR environment variable to contain `ar rpc`. See the
        # discussion in nixpkgs #63056.
        grpc = x.grpc // {
          patches = [ ../fix-grpc-ar.patch ];
          dontBuild = false;
        };
      };
  };
in buildGoPackage rec {
  version = "12.8.8";
  pname = "gitaly";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "182jqglzbzq8jnlq6l634125jkvi67pfr1xck68n4k09gyzqllxv";
  };

  # Fix a check which assumes that hook files are writeable by their
  # owner.
  patches = [ ./fix-executable-check.patch ];

  goPackagePath = "gitlab.com/gitlab-org/gitaly";

  passthru = {
    inherit rubyEnv;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ rubyEnv.wrappedRuby libgit2 ];
  goDeps = ./deps.nix;
  preBuild = "rm -r go/src/gitlab.com/gitlab-org/labkit/vendor";

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib,proto,git-hooks,gitlab-shell} $ruby

    # gitlab-shell will try to read its config relative to the source
    # code by default which doesn't work in nixos because it's a
    # read-only filesystem
    substituteInPlace $ruby/gitlab-shell/lib/gitlab_config.rb --replace \
       "File.join(ROOT_PATH, 'config.yml')" \
       "'/run/gitlab/shell-config.yml'"
  '';

  outputs = [ "bin" "out" "ruby" ];

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/gitlab-org/gitaly;
    description = "A Git RPC service for handling all the git calls made by GitLab";
    platforms = platforms.linux;
    maintainers = with maintainers; [ roblabla globin fpletz ];
    license = licenses.mit;
  };
}
