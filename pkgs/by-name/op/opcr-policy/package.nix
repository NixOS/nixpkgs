{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "opcr-policy";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "opcr-io";
    repo = "policy";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-t1aTFDUdN30murpQ2QNHtEGow21SyioadSYgzmY2WDc=";
  };
  vendorHash = "sha256-d6y3R/oJUfAIZLXanUb0glBsYBLlbSXPvAy1LawW9OM=";

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
    homepage = "https://openpolicycontainers.com/";
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
