{ lib, buildGoModule, fetchFromGitHub }:

# SHA of ${version} for the tool's help output. Unfortunately this is needed in build flags.
let rev = "08bb70f407d0334fa80b9dbc6850987f16eb27d3";
in
buildGoModule rec {
  pname = "sonobuoy";
  version = "0.54.0"; # Do not forget to update `rev` above

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
    sha256 = "sha256-Gtpky+zkFKukIIHF91F4uBZjaguk8KlOEVhSwTj+ccs=";
  };

  vendorSha256 = "sha256-Lkwv95BZa7nFEXk1KcwXIRVpj9DZmqnWjkdrZkO/k24=";

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
