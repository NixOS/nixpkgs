{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  sonobuoy,
}:

# SHA of ${version} for the tool's help output. Unfortunately this is needed in build flags.
# The update script can update this automatically, the comment is used to find the line.
let
  rev = "a988242e8bbded3ef4602eda48addcfac24a1a91"; # update-commit-sha
in
buildGoModule rec {
  pname = "sonobuoy";
  version = "0.57.3"; # Do not forget to update `rev` above

  ldflags =
    let
      t = "github.com/vmware-tanzu/sonobuoy";
    in
    [
      "-s"
      "-X ${t}/pkg/buildinfo.Version=v${version}"
      "-X ${t}/pkg/buildinfo.GitSHA=${rev}"
      "-X ${t}/pkg/buildDate=unknown"
    ];

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "sonobuoy";
    rev = "v${version}";
    hash = "sha256-YFItnwU08g4pVo4OOHscRmPRVXyr+R9YWYTxhSzd7iI=";
  };

  vendorHash = "sha256-QjVnC6CZXuw6qLNyX9ut2g1Ws1cYO1JuT043aqqeF0Q=";

  subPackages = [ "." ];

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = sonobuoy;
      command = "sonobuoy version";
      version = "v${version}";
    };
  };

  meta = {
    description = "Diagnostic tool that makes it easier to understand the state of a Kubernetes cluster";
    longDescription = ''
      Sonobuoy is a diagnostic tool that makes it easier to understand the state of
      a Kubernetes cluster by running a set of Kubernetes conformance tests in an
      accessible and non-destructive manner.
    '';

    homepage = "https://sonobuoy.io";
    changelog = "https://github.com/vmware-tanzu/sonobuoy/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "sonobuoy";
    maintainers = with lib.maintainers; [
      carlosdagos
      saschagrunert
      wilsonehusin
    ];
  };
}
