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
  };

  version = "14.9.4";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/v${lib.versions.major version}";
in

buildGoModule {
  pname = "gitaly";
  inherit version;

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "sha256-VRAKvsA2J8m1iE/LtGb8NovC9y1DzBn5hy6qQbAuBWM=";
  };

  vendorSha256 = "sha256-kEjgWA/Task23PScPYrqdDu3vdVR/FJl7OilUug/Bds=";

  passthru = {
    inherit rubyEnv;
  };

  ldflags = "-X ${gitaly_package}/internal/version.version=${version} -X ${gitaly_package}/internal/version.moduleVersion=${version}";

  tags = [ "static,system_libgit2" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ rubyEnv.wrappedRuby libgit2 openssl zlib pcre http-parser ];
  doCheck = false;

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib,proto} $ruby
    mv $out/bin/gitaly-git2go $out/bin/gitaly-git2go-${version}
  '';

  outputs = [ "out" "ruby" ];

  meta = with lib; {
    homepage = "https://gitlab.com/gitlab-org/gitaly";
    description = "A Git RPC service for handling all the git calls made by GitLab";
    platforms = platforms.linux;
    maintainers = with maintainers; [ roblabla globin fpletz talyz yayayayaka ];
    license = licenses.mit;
  };
}
