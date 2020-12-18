{ lib, buildGoModule, fetchFromGitHub }:

# SHA of ${version} for the tool's help output
let rev = "e03f9ee353717ccc5f58c902633553e34b2fe46a";
in
buildGoModule rec {
  pname = "sonobuoy";
  version = "0.19.0";

  buildFlagsArray =
    let t = "github.com/vmware-tanzu/sonobuoy";
    in ''
      -ldflags=
        -s -X ${t}/pkg/buildinfo.Version=v${version}
           -X ${t}/pkg/buildinfo.GitSHA=${rev}
           -X ${t}/pkg/buildDate=unknown
    '';

  src = fetchFromGitHub {
    sha256 = "1gw58a30akidk15wk8kk7f8lsyqr1q180j6fzr4462ahwxdbjgkr";
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
