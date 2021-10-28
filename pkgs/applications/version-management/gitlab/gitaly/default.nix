{ lib, fetchFromGitLab, fetchFromGitHub, buildGoModule, ruby
, bundlerEnv, pkg-config
# libgit2 + dependencies
, libgit2, openssl, zlib, pcre, http-parser }:

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
  version = "14.4.1";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/v${lib.versions.major version}";
in

buildGoModule {
  pname = "gitaly";
  inherit version;

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "sha256-bATqaB7q3MlyacEiBXdcEDs+xsJUbULVnYTSpEznxFg=";
  };

  vendorSha256 = "sha256-9RhPQosen70E9t1iAoc2SeKs9pYMMpMqgXLekWfKNf8=";

  passthru = {
    inherit rubyEnv;
  };

  buildFlagsArray = [
    "-ldflags= -X ${gitaly_package}/internal/version.version=${version} -X ${gitaly_package}/internal/version.moduleVersion=${version}"
  ];

  buildFlags = [ "-tags=static,system_libgit2" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ rubyEnv.wrappedRuby libgit2 openssl zlib pcre http-parser ];
  doCheck = false;

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib,proto,git-hooks} $ruby
    mv $out/bin/gitaly-git2go $out/bin/gitaly-git2go-${version}
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
