{ stdenv, fetchFromGitLab, buildGoPackage, ruby, bundlerEnv, pkgconfig, libgit2 }:

let
  rubyEnv = bundlerEnv rec {
    name = "gitaly-env";
    inherit ruby;
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
  version = "1.47.0";
  name = "gitaly-${version}";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "1b8gshvwiypwl0f4963l37y7sjrn851marr77fhczx128axrniiw";
  };

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
    cp -rv $src/ruby/{bin,lib,git-hooks,gitlab-shell} $ruby

    # gitlab-shell will try to read its config relative to the source
    # code by default which doesn't work in nixos because it's a
    # read-only filesystem
    substituteInPlace $ruby/gitlab-shell/lib/gitlab_config.rb --replace \
       "File.join(ROOT_PATH, 'config.yml')" \
       "'/run/gitlab/shell-config.yml'"
  '';

  outputs = [ "bin" "out" "ruby" ];

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ roblabla globin fpletz ];
    license = licenses.mit;
  };
}
