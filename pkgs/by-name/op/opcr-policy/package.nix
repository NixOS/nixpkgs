{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "opcr-policy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "opcr-io";
    repo = "policy";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-I086Dj8N+L95beQ5oIXcTwd8ZnD8pvA+dL9576a+wAQ=";
  };
  vendorHash = "sha256-S0lTfc09KW8psuZb0flxBMwHsvzsR1XSyObA8jACD+w=";

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
