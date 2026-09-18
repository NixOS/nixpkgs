{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "netassert";
  version = "2.1.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = "netassert";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ef4KRsbgqhYMSuddBBa9J5+FQ7mG1MtjVhqwE91v77A=";
  };
  vendorHash = "sha256-eathx5R8iYLNitpt7YHZz7xRs6u2hVBNskxAfphvQ40=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.src.rev}"
  ];

  postBuild = ''
    mv $GOPATH/bin/{cli,netassert}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
