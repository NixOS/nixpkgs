{ lib
, fetchFromGitLab
, fetchFromGitHub
, buildGoModule
, pkg-config
}:

let
  version = "17.0.1";
  package_version = "v${lib.versions.major version}";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/${package_version}";

  commonOpts = {
    inherit version;

    # nixpkgs-update: no auto update
    src = fetchFromGitLab {
      owner = "gitlab-org";
      repo = "gitaly";
      rev = "v${version}";
      hash = "sha256-TUzfFs5JMhyLtu/EZKxL/er3XF26owzo3BMBU31tm3c=";
    };

    vendorHash = "sha256-rRIkbtzl7/xi/ul+cHezGShE7QL0dVVzfKY/g2N/f90=";

    ldflags = [ "-X ${gitaly_package}/internal/version.version=${version}" "-X ${gitaly_package}/internal/version.moduleVersion=${version}" ];

    tags = [ "static" ];

    nativeBuildInputs = [ pkg-config ];

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
    cp -r ${auxBins}/bin/* _build/bin
  '';

  outputs = [ "out" ];

  meta = with lib; {
    homepage = "https://gitlab.com/gitlab-org/gitaly";
    description = "A Git RPC service for handling all the git calls made by GitLab";
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
    maintainers = teams.gitlab.members;
    license = licenses.mit;
  };
} // commonOpts)
