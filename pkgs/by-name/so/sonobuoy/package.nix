{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  sonobuoy,
}:

# SHA of ${finalAttrs.version} for the tool's help output. Unfortunately this is needed in build flags.
# The update script can update this automatically, the comment is used to find the line.
let
  rev = "310c51d9874a4d10d021ec8a19f8b42292ec0bfc"; # update-commit-sha
in
buildGoModule (finalAttrs: {
  pname = "sonobuoy";
  version = "0.57.5"; # Do not forget to update `rev` above

  ldflags =
    let
      t = "github.com/vmware-tanzu/sonobuoy";
    in
    [
      "-s"
      "-X ${t}/pkg/buildinfo.Version=v${finalAttrs.version}"
      "-X ${t}/pkg/buildinfo.GitSHA=${rev}"
      "-X ${t}/pkg/buildDate=unknown"
    ];

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "sonobuoy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yd2a4FeWpONn/SQ1UEVN6f1RwgOT4Sbs6rSYDAuTqCU=";
  };

  vendorHash = "sha256-saReHf6oYu1IydP0qNEuFCtrqHDsHoHlPJpo9kSIEiQ=";

  subPackages = [ "." ];

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = sonobuoy;
      command = "sonobuoy version";
      version = "v${finalAttrs.version}";
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
    changelog = "https://github.com/vmware-tanzu/sonobuoy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "sonobuoy";
    maintainers = with lib.maintainers; [
      carlosdagos
      saschagrunert
      wilsonehusin
    ];
  };
})
