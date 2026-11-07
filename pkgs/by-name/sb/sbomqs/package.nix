{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "sbomqs";
  version = "2.1.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "interlynk-io";
    repo = "sbomqs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-I3KxHXcAqLD94/pt2aE/V21xIN5OBVkVp5LWeIuf+iA=";
  };

  vendorHash = "sha256-yEIY5qaXiT1TNoj/t3S0CG8SR5dMr/uDEFfgdoLdSSs=";

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = with lib; {
    description = "A comprehensive SBOM quality and compliance tool";
    homepage = "https://github.com/interlynk-io/sbomqs";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "sbomqs";
  };
})
