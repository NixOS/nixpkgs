{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  generic =
    {
      version,
      sha256,
      rev ? version,
      ...
    }@attrs:
    let
      attrs' = removeAttrs attrs [
        "version"
        "sha256"
        "rev"
      ];
    in
    buildGoModule {
      pname = "kops";
      inherit version;

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
        "-X k8s.io/kops.Version=${version}"
        "-X k8s.io/kops.GitVersion=${version}"
      ];

      doCheck = false;

      postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        installShellCompletion --cmd kops \
          --bash <($GOPATH/bin/kops completion bash) \
          --fish <($GOPATH/bin/kops completion fish) \
          --zsh <($GOPATH/bin/kops completion zsh)
      '';

      meta = with lib; {
        description = "Easiest way to get a production Kubernetes up and running";
        mainProgram = "kops";
        homepage = "https://github.com/kubernetes/kops";
        changelog = "https://github.com/kubernetes/kops/tree/master/docs/releases";
        license = licenses.asl20;
        maintainers = with maintainers; [
          offline
          zimbatm
          yurrriq
        ];
      };
    }
    // attrs';
in
rec {
  mkKops = generic;

  kops_1_31 = mkKops rec {
    version = "1.31.0";
    sha256 = "sha256-q9megrNXXKJ/YqP/fjPHh8Oji4dPK5M3HLHa+ufwRAM=";
    rev = "v${version}";
  };

  kops_1_32 = mkKops rec {
    version = "1.32.1";
    sha256 = "sha256-nQKeTDajtUffPBhPrPuaJ+1XWgLDUltwDQDZHkylys4=";
    rev = "v${version}";
  };

  kops_1_33 = mkKops rec {
    version = "1.33.0";
    sha256 = "sha256-VnnKWcU83yqsKW54Q1tr99/Ln8ppMyB7GLl70rUFGDY=";
    rev = "v${version}";
  };
}
