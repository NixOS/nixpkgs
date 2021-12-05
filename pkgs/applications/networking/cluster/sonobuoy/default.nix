{ lib, buildGoModule, fetchFromGitHub }:

# SHA of ${version} for the tool's help output. Unfortunately this is needed in build flags.
let rev = "dc78b39a6ff0a1a94a29fa0fd72bcbe5d95004be";
in buildGoModule rec {
  pname = "sonobuoy";
  version = "0.55.0"; # Do not forget to update `rev` above

  ldflags = let t = "github.com/vmware-tanzu/sonobuoy";
  in [
    "-s"
    "-X ${t}/pkg/buildinfo.Version=v${version}"
    "-X ${t}/pkg/buildinfo.GitSHA=${rev}"
    "-X ${t}/pkg/buildDate=unknown"
  ];

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "sonobuoy";
    rev = "v${version}";
    sha256 = "sha256-fMZju0Cd1JtVC+EKHwW3ZGsB2m0V3UIHsKQMbvf4i5Y=";
  };

  vendorSha256 = "sha256-jPKCWTFABKRZCg6X5VVdrmOU/ZFc7yGD7R8RJrpcITg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = ''
      Diagnostic tool that makes it easier to understand the
      state of a Kubernetes cluster.
    '';
    longDescription = ''
      Sonobuoy is a diagnostic tool that makes it easier to understand the state of
      a Kubernetes cluster by running a set of Kubernetes conformance tests in an
      accessible and non-destructive manner.
    '';

    homepage = "https://sonobuoy.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos saschagrunert wilsonehusin ];
  };
}
