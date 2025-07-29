{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "netassert";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = "netassert";
    rev = "v${version}";
    hash = "sha256-72LwWzn9sQNbtPj8X0WsR0j0Cs0s00ogcYfQqULTffw=";
  };
  vendorHash = "sha256-JuyE1pYlTIeG3IGOsvYgQN1lTAb7NWytkp/Ibh91QgA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${src.rev}"
  ];

  postBuild = ''
    mv $GOPATH/bin/{cli,netassert}
  '';

  meta = with lib; {
    homepage = "https://github.com/controlplaneio/netassert";
    changelog = "https://github.com/controlplaneio/netassert/blob/${src.rev}/CHANGELOG.md";
    description = "Command line utility to test network connectivity between kubernetes objects";
    longDescription = ''
      NetAssert is a command line utility to test network connectivity between kubernetes objects.
      It currently supports Deployment, Pod, Statefulset and Daemonset.
      You can check the traffic flow between these objects or from these objects to a remote host or an IP address.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    mainProgram = "netassert";
  };
}
