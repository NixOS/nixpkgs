{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "naabu";
  version = "2.3.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    tag = "v${version}";
    hash = "sha256-caiUb++eaZN+v/uZ/kgBMztv0saSiBrpqQ2QMbgjLlY=";
  };

  vendorHash = "sha256-RGDMOR65IWtkBnVX2NCIu20vvuQNi0+mBcf0Sc8EXJg=";

  buildInputs = [ libpcap ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  subPackages = [ "cmd/naabu/" ];

  ldflags = [
    "-w"
    "-s"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = "-version";

  meta = {
    description = "Fast SYN/CONNECT port scanner";
    longDescription = ''
      Naabu is a port scanning tool written in Go that allows you to enumerate
      valid ports for hosts in a fast and reliable manner. It is a really simple
      tool that does fast SYN/CONNECT scans on the host/list of hosts and lists
      all ports that return a reply.
    '';
    homepage = "https://github.com/projectdiscovery/naabu";
    changelog = "https://github.com/projectdiscovery/naabu/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "naabu";
  };
}
