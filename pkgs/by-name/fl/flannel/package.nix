{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "flannel";
  version = "0.28.11";
  rev = "v${version}";

  vendorHash = "sha256-Ub1U73XxeONadVJwKJ0lDWY1EJfArVpOfCPKxT8Gpsc=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-FCz16X/pBt7yQjPGVOcOtjvUNiM+7fMlHPhl5/34jPE=";
  };

  ldflags = [ "-X github.com/flannel-io/flannel/pkg/version.Version=${rev}" ];

  # TestRouteCache/TestV6RouteCache fail with "Failed to create newns: operation not permitted"
  doCheck = false;

  passthru.tests = { inherit (nixosTests) flannel; };

  meta = {
    description = "Network fabric for containers, designed for Kubernetes";
    license = lib.licenses.asl20;
    homepage = "https://github.com/flannel-io/flannel";
    maintainers = with lib.maintainers; [
      johanot
    ];
    platforms = with lib.platforms; linux;
    mainProgram = "flannel";
  };
}
