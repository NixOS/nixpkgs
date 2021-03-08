{ lib, fetchFromGitLab, fetchFromGitHub, buildGoModule, ruby
, bundlerEnv, pkg-config
# libgit2 + dependencies
, libgit2, openssl, zlib, pcre, http-parser }:

let
  # libgit2 was updated to 1.1.0 in nixpkgs, but gitlab doesn't support that yet.
  # See https://github.com/NixOS/nixpkgs/pull/106909
  libgit = libgit2.overrideAttrs (attrs: rec {
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "libgit2";
      repo = "libgit2";
      rev = "v${version}";
      sha256 = "06cwrw93ycpfb5kisnsa5nsy95pm11dbh0vvdjg1jn25h9q5d3vc";
    };
  });

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
in buildGoModule rec {
  version = "13.8.5";
  pname = "gitaly";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "sha256-hKIjKltPPmz50Ru7elpHdeoyGAqgp+txR3fKleqY7hM=";
  };

  vendorSha256 = "sha256-oVw6vXI3CyOn4l02PkYx3HVpZfzQPi3yBuf9tRvoWoM=";

  passthru = {
    inherit rubyEnv;
  };

  buildFlags = [ "-tags=static,system_libgit2" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ rubyEnv.wrappedRuby libgit openssl zlib pcre http-parser ];
  doCheck = false;

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib,proto,git-hooks} $ruby
  '';

  outputs = [ "out" "ruby" ];

  meta = with lib; {
    homepage = "https://gitlab.com/gitlab-org/gitaly";
    description = "A Git RPC service for handling all the git calls made by GitLab";
    platforms = platforms.linux;
    maintainers = with maintainers; [ roblabla globin fpletz talyz ];
    license = licenses.mit;
  };
}
