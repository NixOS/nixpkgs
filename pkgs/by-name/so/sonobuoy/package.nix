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
  rev = "09b10f4ef2c32b3ee04ec59821ccae492e1e140d"; # update-commit-sha
in
buildGoModule (finalAttrs: {
  pname = "sonobuoy";
  version = "0.57.4"; # Do not forget to update `rev` above

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
    hash = "sha256-LFYn7Ym1RS8/Uysm6I2HbVD48fu542TsHdqybzvLgrw=";
  };

  vendorHash = "sha256-0PELYc2CK8FCDUvQomY6AkYd7VmhmTai64ITbpudMc4=";

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
