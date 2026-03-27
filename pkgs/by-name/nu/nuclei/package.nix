{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "nuclei";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PiuFlEIEQNsVLLwHVDi+b/ABPyrp4+hnO6JjLGHxWc0=";
  };

  vendorHash = "sha256-eevywU57QoA2K/Fl4XQZwaiyGCiGDrkvAdco6khcInc=";

  proxyVendor = true; # hash mismatch between Linux and Darwin

  subPackages = [ "cmd/nuclei/" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-w"
    "-s"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  doInstallCheck = true;

  versionCheckProgramArg = "-version";

  meta = {
    description = "Tool for configurable targeted scanning";
    longDescription = ''
      Nuclei is used to send requests across targets based on a template
      leading to zero false positives and providing effective scanning
      for known paths. Main use cases for nuclei are during initial
      reconnaissance phase to quickly check for low hanging fruits or
      CVEs across targets that are known and easily detectable.
    '';
    homepage = "https://github.com/projectdiscovery/nuclei";
    changelog = "https://github.com/projectdiscovery/nuclei/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      Misaka13514
    ];
    mainProgram = "nuclei";
  };
})
