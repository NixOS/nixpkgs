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

  version = "15.8.4";
  package_version = "v${lib.versions.major version}";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/${package_version}";

  commonOpts = {
    inherit version;

    src = fetchFromGitLab {
      owner = "gitlab-org";
      repo = "gitaly";
      rev = "v${version}";
      sha256 = "sha256-att8MR94uINKOTYlj2sZLezMXZag11qP2p9T9a3Eklc=";
    };

    vendorSha256 = "sha256-8P5X/bqeI1hY45IGsvEWOg3GuetEQF/XtZzUMdX22pA=";

    ldflags = [ "-X ${gitaly_package}/internal/version.version=${version}" "-X ${gitaly_package}/internal/version.moduleVersion=${version}" ];

    tags = [ "static,system_libgit2" ];

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ rubyEnv.wrappedRuby libgit2 openssl zlib pcre http-parser ];

    doCheck = false;
  };

  auxBins = buildGoModule ({
    pname = "gitaly-aux";

    subPackages = [ "cmd/gitaly-hooks" "cmd/gitaly-ssh" "cmd/gitaly-git2go" "cmd/gitaly-lfs-smudge" ];
  } // commonOpts);
in
buildGoModule ({
  pname = "gitaly";

  passthru = {
    inherit rubyEnv;
  };

  subPackages = [ "cmd/gitaly" "cmd/gitaly-backup" ];

  preConfigure = ''
    mkdir -p _build/bin
    cp -r ${auxBins}/bin/* _build/bin
  '';

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib} $ruby
  '';

  outputs = [ "out" "ruby" ];

  meta = with lib; {
    homepage = "https://gitlab.com/gitlab-org/gitaly";
    description = "A Git RPC service for handling all the git calls made by GitLab";
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
    maintainers = with maintainers; [ roblabla globin talyz yayayayaka ];
    license = licenses.mit;
  };
} // commonOpts)
