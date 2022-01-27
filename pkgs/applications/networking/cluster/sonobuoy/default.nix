{ lib, buildGoModule, fetchFromGitHub }:

# SHA of ${version} for the tool's help output. Unfortunately this is needed in build flags.
let rev = "0665cd322b11bb40c2774776de765c38d8104bed";
in
buildGoModule rec {
  pname = "sonobuoy";
  version = "0.56.0"; # Do not forget to update `rev` above

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
    sha256 = "sha256-78skqo3sq567s3/XN54xtC0mefDY3Io3BD0d+JP7k5Q=";
  };

  vendorSha256 = "sha256-qKXm39CwrTcXENIMh2BBS3MUlhJvmTTA3UzZNpF0PCc=";

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
