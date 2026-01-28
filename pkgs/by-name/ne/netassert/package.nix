{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "netassert";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = "netassert";
    rev = "v${version}";
    hash = "sha256-Osf6JIQ+h+hw6tN+CPz21nmAp5LJi5dayq38xb1J578=";
  };
  vendorHash = "sha256-iipYu/thw0F0vrj6NWPJrd4CcDmgrPCs6TJZcBqbfSg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${src.rev}"
  ];

  postBuild = ''
    mv $GOPATH/bin/{cli,netassert}
  '';

  meta = {
    homepage = "https://github.com/controlplaneio/netassert";
    changelog = "https://github.com/controlplaneio/netassert/blob/${src.rev}/CHANGELOG.md";
    description = "Command line utility to test network connectivity between kubernetes objects";
    longDescription = ''
      NetAssert is a command line utility to test network connectivity between kubernetes objects.
      It currently supports Deployment, Pod, Statefulset and Daemonset.
      You can check the traffic flow between these objects or from these objects to a remote host or an IP address.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jk ];
    mainProgram = "netassert";
  };
}
