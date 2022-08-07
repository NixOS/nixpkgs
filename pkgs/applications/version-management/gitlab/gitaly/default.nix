{ lib, fetchFromGitLab, fetchFromGitHub, buildGoModule, ruby
, bundlerEnv, pkg-config
# libgit2 + dependencies
, libgit2_1_3_0, openssl, zlib, pcre, http-parser }:

let
  rubyEnv = bundlerEnv rec {
    name = "gitaly-env";
    inherit ruby;
    copyGemFiles = true;
    gemdir = ./.;
  };

  version = "15.1.4";
  package_version = "v${lib.versions.major version}";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/${package_version}";
in

buildGoModule {
  pname = "gitaly";
  inherit version;

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "sha256-7bsbmC+a+Qk0MevAJvbQoRfvd3G7+q2zY6Gsb5yP44U=";
  };

  vendorSha256 = "sha256-0JWJ2mpf79gJdnNRdlQLi0oDvnj6VmibkW2XcPnaCww=";

  passthru = {
    inherit rubyEnv;
  };

  ldflags = [ "-X ${gitaly_package}/internal/version.version=${version}" "-X ${gitaly_package}/internal/version.moduleVersion=${version}" ];

  tags = [ "static,system_libgit2" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ rubyEnv.wrappedRuby libgit2_1_3_0 openssl zlib pcre http-parser ];
  doCheck = false;

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib,proto} $ruby
    mv $out/bin/gitaly-git2go-${package_version} $out/bin/gitaly-git2go-${version}
  '';

  outputs = [ "out" "ruby" ];

  meta = with lib; {
    homepage = "https://gitlab.com/gitlab-org/gitaly";
    description = "A Git RPC service for handling all the git calls made by GitLab";
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
    maintainers = with maintainers; [ roblabla globin talyz yayayayaka ];
    license = licenses.mit;
  };
}
