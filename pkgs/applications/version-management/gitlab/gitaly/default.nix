{ stdenv, fetchFromGitLab, fetchFromGitHub, buildGoPackage, ruby,
  bundlerEnv, pkgconfig, libgit2_0_27 }:

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
  version = "13.0.9";
  pname = "gitaly";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "0bw3g1c3ji78grh6fs4qq64hq1s4z2da5f18zbkac41hkkqbf1in";
  };

  # Fix a check which assumes that hook files are writeable by their
  # owner.
  patches = [
    ./fix-executable-check.patch
  ];

  goPackagePath = "gitlab.com/gitlab-org/gitaly";

  passthru = {
    inherit rubyEnv;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ rubyEnv.wrappedRuby libgit2_0_27 ];
  goDeps = ./deps.nix;
  preBuild = "rm -r go/src/gitlab.com/gitlab-org/labkit/vendor";

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib,proto,git-hooks,gitlab-shell} $ruby
  '';

  outputs = [ "out" "ruby" ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.com/gitlab-org/gitaly";
    description = "A Git RPC service for handling all the git calls made by GitLab";
    platforms = platforms.linux;
    maintainers = with maintainers; [ roblabla globin fpletz talyz ];
    license = licenses.mit;
  };
}
