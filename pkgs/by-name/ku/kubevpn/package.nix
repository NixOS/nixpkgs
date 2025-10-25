{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  go,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubevpn";
  version = "2.9.10";

  src = fetchFromGitHub {
    owner = "KubeNetworks";
    repo = "kubevpn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5yuJfGWNEQ/1ufV1rVze2JrL/67/UlYdG2YH9i+gI3w=";
  };

  vendorHash = null;

  tags = [
    "noassets" # required to build synthing gui without generating assets
  ];

  ldflags = [
    "-X github.com/wencaiwulue/kubevpn/v2/pkg/config.Version=v${finalAttrs.version}"
    "-X github.com/wencaiwulue/kubevpn/v2/cmd/kubevpn/cmds.OsArch=${go.GOOS}/${go.GOARCH}"
  ];

  # Resolve configuration tests, which access $HOME
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags =
    let
      skippedTests = [
        # Disable network tests
        "TestRoute"
        "TestFunctions"
        "TestByDumpClusterInfo"
        "TestByCreateSvc"
        "TestElegant"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # Not sure why these test fail on darwin with __darwinAllowLocalNetworking.
        "TestHttpOverUnix"
        "TestConnectionRefuse"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";

  meta = {
    changelog = "https://github.com/KubeNetworks/kubevpn/releases/tag/${finalAttrs.src.rev}";
    description = "Create a VPN and connect to Kubernetes cluster network, access resources, and more";
    mainProgram = "kubevpn";
    homepage = "https://github.com/KubeNetworks/kubevpn";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mig4ng ];
  };
})
