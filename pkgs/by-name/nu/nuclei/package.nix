{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "nuclei";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei";
    tag = "v${version}";
    hash = "sha256-85gGcNDuARc7sMJcl3yVwuTYG0laQ5/Uk7qxcXFeViQ=";
  };

  vendorHash = "sha256-VKszu2WNLL2gSkgyAoA80HkYGD6kRdfj5fGLErjL86A=";

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
    changelog = "https://github.com/projectdiscovery/nuclei/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      Misaka13514
    ];
    mainProgram = "nuclei";
  };
}
