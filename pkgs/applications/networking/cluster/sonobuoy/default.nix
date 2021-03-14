{ lib, buildGoModule, fetchFromGitHub }:

# SHA of ${version} for the tool's help output. Unfortunately this is needed in build flags.
let rev = "f6e19140201d6bf2f1274bf6567087bc25154210";
in
buildGoModule rec {
  pname = "sonobuoy";
  version = "0.20.0"; # Do not forget to update `rev` above

  buildFlagsArray =
    let t = "github.com/vmware-tanzu/sonobuoy";
    in ''
      -ldflags=
        -s -X ${t}/pkg/buildinfo.Version=v${version}
           -X ${t}/pkg/buildinfo.GitSHA=${rev}
           -X ${t}/pkg/buildDate=unknown
    '';

  src = fetchFromGitHub {
    sha256 = "11qawsv82i1pl4mwfc85wb4fbq961bplvmygnjfm79m8z87863ri";
    rev = "v${version}";
    repo = "sonobuoy";
    owner = "vmware-tanzu";
  };

  vendorSha256 = "1kxzd4czv8992y7y47la5jjrbhk76sxcj3v5sx0k4xplgki7np6i";

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
