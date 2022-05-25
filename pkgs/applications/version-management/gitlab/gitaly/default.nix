{ lib
, fetchFromGitLab
, fetchFromGitHub
, fetchurl
, buildGoModule
, ruby
, bundlerEnv
, pkg-config
, git
  # libgit2 + dependencies
, libgit2_1_3_0
, openssl
, zlib
, pcre
, http-parser
}:

let
  rubyEnv = bundlerEnv rec {
    name = "gitaly-env";
    inherit ruby;
    copyGemFiles = true;
    gemdir = ./.;
  };

  version = "14.10.2";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/v${lib.versions.major version}";
in

buildGoModule rec {
  pname = "gitaly";
  inherit version;

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "sha256-hLTzkW5GDq1AgTwe1pVj6Tiyd0JpJ76ATFu3Q+m9MVg=";
  };

  vendorSha256 = "sha256-ZL61t+Ii2Ns3TmitiF93exinod54+RCqrbdpU67HeY0=";

  passthru = {
    inherit rubyEnv;
    git =
      let
        ver = "2.35.1";
        patchDir = "${src}/_support/git-patches/v${ver}.gl1/";
      in
      git.overrideAttrs (oldAttrs: rec {
        version = ver;
        src = fetchurl {
          url = "https://www.kernel.org/pub/software/scm/git/git-${ver}.tar.xz";
          sha256 = "sha256-12hSjmRD9logMDYmbxylD50Se6iXUeMurTcRftkZEIA=";
        };
        patches = oldAttrs.patches ++ map (p: patchDir + p) (builtins.attrNames (builtins.readDir patchDir));
      });
  };

  ldflags = "-X ${gitaly_package}/internal/version.version=${version} -X ${gitaly_package}/internal/version.moduleVersion=${version}";

  tags = [ "static,system_libgit2" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ rubyEnv.wrappedRuby libgit2_1_3_0 openssl zlib pcre http-parser ];
  doCheck = false;

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib,proto} $ruby
    mv $out/bin/gitaly-git2go-v${lib.versions.major version} $out/bin/gitaly-git2go-${version}
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
