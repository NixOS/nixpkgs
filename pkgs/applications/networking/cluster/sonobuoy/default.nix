{ lib, buildGoPackage, fetchFromGitHub }:

# SHA of ${version} for the tool's help output
let rev = "c9c2a461cd3397909fe6e45ff71836347ef89fd8";
in
buildGoPackage rec {
  pname = "sonobuoy";
  version = "0.16.1";

  goPackagePath = "github.com/heptio/sonobuoy";

  buildFlagsArray =
    let t = goPackagePath;
    in ''
      -ldflags=
        -s -X ${t}/pkg/buildinfo.Version=${version}
           -X ${t}/pkg/buildinfo.GitSHA=${rev}
           -X ${t}/pkg/buildDate=unknown
    '';

  src = fetchFromGitHub {
    sha256 = "14qc5a7jbr403wjpk6pgpb94i72yx647sg9srz07q6drq650kyfv";
    rev = "v${version}";
    repo = "sonobuoy";
    owner = "vmware-tanzu";
  };

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
    maintainers = with maintainers; [ carlosdagos saschagrunert ];
  };
}
