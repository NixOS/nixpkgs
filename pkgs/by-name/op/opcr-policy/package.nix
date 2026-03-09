{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "opcr-policy";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "opcr-io";
    repo = "policy";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-gthl1S3LBDiRH+qPqAWhqTNK0La1nZtuLI4rc9eetlM=";
  };
  vendorHash = "sha256-fLl59sbhJiM7jxum7Xf0G7d7acOc1jhbsRWtPOIWUh8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/opcr-io/policy/pkg/version.ver=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/policy" ];
  # disable go workspaces
  env.GOWORK = "off";

  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/policy --help
    $out/bin/policy version | grep "version: ${finalAttrs.version}"

    runHook postInstallCheck
  '';

  meta = {
    mainProgram = "policy";
    homepage = "https://www.openpolicyregistry.io/";
    changelog = "https://github.com/opcr-io/policy/releases/tag/v${finalAttrs.version}";
    description = "CLI for managing authorization policies";
    longDescription = ''
      The policy CLI is a tool for building, versioning and publishing your authorization policies.
      It uses OCI standards to manage artifacts, and the Open Policy Agent (OPA) to compile and run.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      naphta
      jk
    ];
  };
})
