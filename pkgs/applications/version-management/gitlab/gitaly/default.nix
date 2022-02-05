{ lib, fetchFromGitLab, fetchFromGitHub, buildGoModule, ruby
, bundlerEnv, pkg-config
# libgit2 + dependencies
, libgit2, openssl, zlib, pcre, http-parser }:

let
  # git2go 32.0.5 does not support libgit2 1.2.0 or 1.3.0.
  # It needs a specific commit in between those two releases.
  libgit2_custom = libgit2.overrideAttrs (oldAttrs: rec {
    version = "1.2.0";
    src = fetchFromGitHub {
      owner = "libgit2";
      repo = "libgit2";
      rev = "109b4c887ffb63962c7017a66fc4a1f48becb48e";
      sha256 = "sha256-w029FHpOv5K49wE1OJMOlkTe+2cv+ORYqEHxs59GDBI=";
    };
  });

  rubyEnv = bundlerEnv rec {
    name = "gitaly-env";
    inherit ruby;
    copyGemFiles = true;
    gemdir = ./.;
  };

  version = "14.7.1";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/v${lib.versions.major version}";
in

buildGoModule {
  pname = "gitaly";
  inherit version;

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "sha256-MGcqYbHHeYwjfnvrJG/ZtOnyxsj+w1kPHOkVHf2AeMQ=";
  };

  vendorSha256 = "sha256-eapqtSstc7d3R7A/5krKV0uVr9GhGkHHMrmsBOpWAbo=";

  passthru = {
    inherit rubyEnv;
  };

  ldflags = "-X ${gitaly_package}/internal/version.version=${version} -X ${gitaly_package}/internal/version.moduleVersion=${version}";

  tags = [ "static,system_libgit2" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ rubyEnv.wrappedRuby libgit2_custom openssl zlib pcre http-parser ];
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
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
    maintainers = with maintainers; [ roblabla globin fpletz talyz ];
    license = licenses.mit;
  };
}
