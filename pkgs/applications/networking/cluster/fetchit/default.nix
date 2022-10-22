{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, lvm2
, pkg-config
}:

buildGoModule rec {
  pname = "fetchit";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "fetchit";
    rev = "v${version}";
    sha256 = "sha256-hxS/+/fbYOpMJ5VfvvG5l7wWKBUUR22rYn9X79DzUUk=";
  };

  vendorSha256 = "sha256-SyPd8P9s8R2YbGEPqFeztF98W1QyGSBumtirSdpm8VI=";

  subPackages = [ "cmd/fetchit" ];

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ lvm2 ];

  # Flags are derived from
  # https://github.com/containers/fetchit/blob/v0.0.1/Makefile#L20-L29
  ldflags = [
    "-X k8s.io/client-go/pkg/version.gitMajor=0"
    "-X k8s.io/client-go/pkg/version.gitMinor=0"
    "-X k8s.io/client-go/pkg/version.gitTreeState=clean"
    "-X k8s.io/client-go/pkg/version.gitVersion=v0.0.0"
    "-X k8s.io/component-base/version.gitMajor=0"
    "-X k8s.io/component-base/version.gitMajor=0"
    "-X k8s.io/component-base/version.gitMinor=0"
    "-X k8s.io/component-base/version.gitTreeState=clean"
    "-X k8s.io/component-base/version.gitVersion=v0.0.0"
    "-s"
    "-w"
  ];

  tags = [
    "containers_image_openpgp"
    "exclude_graphdriver_btrfs"
    "gssapi"
    "include_gcs"
    "include_oss"
    "netgo"
    "osusergo"
    "providerless"
  ];

  # There are no tests for cmd/fetchit.
  doCheck = false;

  postInstall = ''
    for i in bash fish zsh; do
      installShellCompletion --cmd fetchit \
        --$i <($out/bin/fetchit completion $i)
    done
  '';

  meta = with lib; {
    description = "A tool to manage the life cycle and configuration of Podman containers";
    longDescription = ''
      FetchIt allows for a GitOps based approach to manage containers running on
      a single host or multiple hosts based on a git repository. This allows for
      us to deploy a new host and provide the host a configuration value for
      FetchIt and automatically any containers defined in the git repository and
      branch will be deployed onto the host. This can be beneficial for
      environments that do not require the complexity of Kubernetes to manage
      the containers running on the host.
    '';
    homepage = "https://fetchit.readthedocs.io";
    changelog = "https://github.com/containers/fetchit/releases/tag/${src.rev}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.linux;
  };
}
