{ lib, buildGoModule, fetchFromGitHub, testers, sonobuoy }:

# SHA of ${version} for the tool's help output. Unfortunately this is needed in build flags.
# The update script can update this automatically, the comment is used to find the line.
let rev = "6f9e27f1795f10475c9f6f5decdff692e1e228da"; # update-commit-sha
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

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = sonobuoy;
      command = "sonobuoy version";
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Diagnostic tool that makes it easier to understand the state of a Kubernetes cluster";
    longDescription = ''
      Sonobuoy is a diagnostic tool that makes it easier to understand the state of
      a Kubernetes cluster by running a set of Kubernetes conformance tests in an
      accessible and non-destructive manner.
    '';

    homepage = "https://sonobuoy.io";
    changelog = "https://github.com/vmware-tanzu/sonobuoy/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "sonobuoy";
    maintainers = with maintainers; [ carlosdagos saschagrunert wilsonehusin ];
  };
}
