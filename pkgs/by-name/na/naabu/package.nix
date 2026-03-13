{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "naabu";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jubam5UoWYWK8AoRVxbaibzU9Qv/X7VFfGtQxoY008Y=";
  };

  vendorHash = "sha256-h0/mTUbgCwzIAvIh9i1ZAgMa9undo8DkC0jGOZdUu20=";

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
    changelog = "https://github.com/projectdiscovery/naabu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "naabu";
  };
})
