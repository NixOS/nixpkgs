{ lib
, buildGoModule
, fetchFromGitHub
, gitUpdater
}:

buildGoModule rec {
  pname = "lxd-to-incus";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    # use commit which fixes 0.1 versioning, use tags for > 0.1
    rev = "253a06bd8506bf42628d32ccbca6409d051465ec";
    hash = "sha256-LXCTrZEDnFTJpqVH+gnG9HaV1wcvTFsVv2tAWabWYmg=";
  };

  modRoot = "cmd/lxd-to-incus";

  vendorHash = "sha256-Kk5sx8UYuip/qik5ez/pxi+DmzjkPIHNYUHVvBm9f9g=";

  # required for go-cowsql.
  CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)";

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "incus-";
    };
  };

  meta = {
    description = "LXD to Incus migration tool";
    homepage = "https://linuxcontainers.org/incus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ adamcstephens ];
    platforms = lib.platforms.linux;
  };
}
