{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "netassert";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = "netassert";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QI2QIj9Hrfp8vNPv0est0NiL956xSZOi2KN7tAFOEtw=";
  };
  vendorHash = "sha256-sMG34WOQD4dPExq+UjnPkvxj3w8bzfAa3azvUvHAMZM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.src.rev}"
  ];

  postBuild = ''
    mv $GOPATH/bin/{cli,netassert}
  '';

  meta = {
    homepage = "https://github.com/controlplaneio/netassert";
    changelog = "https://github.com/controlplaneio/netassert/blob/${finalAttrs.src.rev}/CHANGELOG.md";
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
})
