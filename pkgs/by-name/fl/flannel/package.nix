{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "flannel";
  version = "0.28.7";
  rev = "v${version}";

  vendorHash = "sha256-io2xUh5jM2x7P01MIpPgLAVXC/CAL22zrC6kfi4uYFs=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-K810ikYfDdOtOUTSGqeAwczxNO/XPB+2RbelHBc8tok=";
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
