{ lib, buildGoModule, fetchFromGitHub }:

# SHA of ${version} for the tool's help output. Unfortunately this is needed in build flags.
let rev = "6f9e27f1795f10475c9f6f5decdff692e1e228da";
in
buildGoModule rec {
  pname = "sonobuoy";
  version = "0.57.1"; # Do not forget to update `rev` above

  ldflags =
    let t = "github.com/vmware-tanzu/sonobuoy";
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
    hash = "sha256-e9C5ZwKqT3Fiko2HqrIpONVvjhT8KBBO7rQc3BJhl+A=";
  };

  vendorHash = "sha256-HE53eIEyhOI9ksEx1EKmv/txaTa7KDrNUMEVRMi4Wuo=";

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
