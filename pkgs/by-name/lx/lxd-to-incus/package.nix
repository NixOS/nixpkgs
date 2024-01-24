{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, nix-update-script
}:

buildGoModule rec {
  pname = "lxd-to-incus";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "refs/tags/v${version}";
    hash = "sha256-crWepf5j3Gd1lhya2DGIh/to7l+AnjKJPR+qUd9WOzw=";
  };

  patches = [
    # create migration touch file, remove > 0.4.0
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/edc5fd2a9baccfb7b6814a440e2947cbb580afcf.diff";
      hash = "sha256-ffQfMFrKDPuLU4jVbG/VGHSO3DmeHw30ATJ8yxJAoHQ=";
    })
  ];

  modRoot = "cmd/lxd-to-incus";

  vendorHash = "sha256-cBAqJz3Y4CqyxTt7u/4mXoQPKmKgQ3gYJV1NiC/H+TA=";

  CGO_ENABLED = 0;

  passthru = {
    updateScript = nix-update-script {
       extraArgs = [
        "-vr" "v\(.*\)"
       ];
     };
  };

  meta = {
    description = "LXD to Incus migration tool";
    homepage = "https://linuxcontainers.org/incus";
    license = lib.licenses.asl20;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.linux;
  };
}
