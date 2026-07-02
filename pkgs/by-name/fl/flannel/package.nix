{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "flannel";
  version = "0.28.5";
  rev = "v${version}";

  vendorHash = "sha256-TsMIH1L2LD+LxoAMwtvOa36sakiyxoJ2Av0oW5+dEJQ=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-cG6w2fErJ6lnEfnHXEVwk6dk056bSamPUWquRu1R0QU=";
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
