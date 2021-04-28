{ lib, buildGoModule, fetchFromGitHub }:

# SHA of ${version} for the tool's help output. Unfortunately this is needed in build flags.
let rev = "f6e19140201d6bf2f1274bf6567087bc25154210";
in
buildGoModule rec {
  pname = "sonobuoy";
  version = "0.50.0"; # Do not forget to update `rev` above

  buildFlagsArray =
    let t = "github.com/vmware-tanzu/sonobuoy";
    in ''
      -ldflags=
        -s -X ${t}/pkg/buildinfo.Version=v${version}
           -X ${t}/pkg/buildinfo.GitSHA=${rev}
           -X ${t}/pkg/buildDate=unknown
    '';

  src = fetchFromGitHub {
    sha256 = "sha256-LhprsDlWZjNRE6pu7V9WBszy/+bNpn5KoRopIoWvdsg=";
    rev = "v${version}";
    repo = "sonobuoy";
    owner = "vmware-tanzu";
  };

  vendorSha256 = "sha256-0Vx74nz0djJB12UPybo2Z8KVpSyKHuKPFymh/Rlpv88=";

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
