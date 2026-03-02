{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  testers,
  kubevirt,
}:

buildGoModule (finalAttrs: {
  pname = "kubevirt";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "kubevirt";
    repo = "kubevirt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0dfZbhcFSIU9TFxQ3UT8Sz+tgeiqVke+RxVwlxw49Hk=";
  };

  vendorHash = null;

  subPackages = [ "cmd/virtctl" ];

  tags = [ "selinux" ];

  ldflags = [
    "-X kubevirt.io/client-go/version.gitCommit=v${finalAttrs.version}"
    "-X kubevirt.io/client-go/version.gitTreeState=clean"
    "-X kubevirt.io/client-go/version.gitVersion=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd virtctl \
      --bash <($out/bin/virtctl completion bash) \
      --fish <($out/bin/virtctl completion fish) \
      --zsh <($out/bin/virtctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kubevirt;
    command = "virtctl version --client";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Client tool to use advanced features such as console access";
    homepage = "https://kubevirt.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      haslersn
      johanot
    ];
    mainProgram = "virtctl";
  };
})
