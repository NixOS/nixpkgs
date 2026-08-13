{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:
lib.extendMkDerivation {
  constructDrv = buildGoModule;

  excludeDrvArgNames = [
    "sha256"
    "rev"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      version,
      sha256,
      rev ? version,
      ...
    }:
    {
      pname = "kops";

      src = fetchFromGitHub {
        rev = rev;
        owner = "kubernetes";
        repo = "kops";
        inherit sha256;
      };

      vendorHash = null;

      nativeBuildInputs = [ installShellFiles ];

      subPackages = [ "cmd/kops" ];

      ldflags = [
        "-s"
        "-w"
        "-X k8s.io/kops.Version=${finalAttrs.version}"
        "-X k8s.io/kops.GitVersion=${finalAttrs.version}"
      ];

      doCheck = false;

      postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        installShellCompletion --cmd kops \
          --bash <($GOPATH/bin/kops completion bash) \
          --fish <($GOPATH/bin/kops completion fish) \
          --zsh <($GOPATH/bin/kops completion zsh)
      '';

      meta = {
        description = "Easiest way to get a production Kubernetes up and running";
        mainProgram = "kops";
        homepage = "https://github.com/kubernetes/kops";
        changelog = "https://github.com/kubernetes/kops/tree/master/docs/releases";
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [
          zimbatm
          yurrriq
        ];
      };
    };
}
