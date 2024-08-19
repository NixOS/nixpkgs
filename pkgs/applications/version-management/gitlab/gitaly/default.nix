{ lib
, callPackage
, fetchFromGitLab
, buildGoModule
, pkg-config
}:

let
  version = "17.3.0";
  package_version = "v${lib.versions.major version}";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/${package_version}";

  git = callPackage ./git.nix { };

  commonOpts = {
    inherit version;

    # nixpkgs-update: no auto update
    src = fetchFromGitLab {
      owner = "gitlab-org";
      repo = "gitaly";
      rev = "v${version}";
      hash = "sha256-WFShcPw2i7/v/8iK4LKPlK9DTkpm/HU3kBsuulKGsoo=";
    };

    vendorHash = "sha256-spfSOOe+9NGu+2ZbEGb93X3HnANEXYbvP73DD6neIXQ=";

    ldflags = [ "-X ${gitaly_package}/internal/version.version=${version}" "-X ${gitaly_package}/internal/version.moduleVersion=${version}" ];

    tags = [ "static" ];

    doCheck = false;
  };

  auxBins = buildGoModule ({
    pname = "gitaly-aux";

    subPackages = [ "cmd/gitaly-hooks" "cmd/gitaly-ssh" "cmd/gitaly-lfs-smudge" "cmd/gitaly-gpg" ];
  } // commonOpts);
in
buildGoModule ({
  pname = "gitaly";

  subPackages = [ "cmd/gitaly" "cmd/gitaly-backup" ];

  preConfigure = ''
    mkdir -p _build/bin

    pushd _build/bin
    cp -r ${auxBins}/bin/* .
    cp -r ${git}/bin/* .

    # git binary names are expected to start with "gitaly-"
    # https://gitlab.com/gitlab-org/gitaly/-/merge_requests/7035
    for file in git-*; do mv "$file" "gitaly-$file"; done
    popd
  '';

  outputs = [ "out" ];

  buildInputs = [ git ];

  passthru = {
    inherit git;
  };

  meta = with lib; {
    homepage = "https://gitlab.com/gitlab-org/gitaly";
    description = "Git RPC service for handling all the git calls made by GitLab";
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
    maintainers = teams.gitlab.members;
    license = licenses.mit;
  };
} // commonOpts)
