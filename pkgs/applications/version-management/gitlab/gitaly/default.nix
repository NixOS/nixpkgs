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

  version = "15.0.0";
  package_version = "v14";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/${package_version}";
in

buildGoModule {
  pname = "gitaly";
  inherit version;

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "sha256-ib/gGkXo6W6LZ6j92oUMhJWdDYZRnA1p+tsOK6ewemk=";
  };

  vendorSha256 = "sha256-/tHKWo09ZV31TSIqlOk36V3y7gNikziUJHf+nS1gHEw=";

  passthru = {
    inherit rubyEnv;
  };

  ldflags = "-X ${gitaly_package}/internal/version.version=${version} -X ${gitaly_package}/internal/version.moduleVersion=${version}";

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
    maintainers = with maintainers; [ roblabla globin fpletz talyz yayayayaka ];
    license = licenses.mit;
  };
}
