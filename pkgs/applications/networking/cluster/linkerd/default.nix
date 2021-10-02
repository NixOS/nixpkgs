{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

let generic = { channel, version, sha256, vendorSha256 }:
  buildGoModule rec {
    pname = "linkerd-${channel}";
    inherit version vendorSha256;

    src = fetchFromGitHub {
      owner = "linkerd";
      repo = "linkerd2";
      rev = "${channel}-${version}";
      inherit sha256;
    };

    subPackages = [ "cli" ];
    runVend = true;

    preBuild = ''
      env GOFLAGS="" go generate ./pkg/charts/static
      env GOFLAGS="" go generate ./jaeger/static
      env GOFLAGS="" go generate ./multicluster/static
      env GOFLAGS="" go generate ./viz/static
    '';

    tags = [
      "prod"
    ];

    ldflags = [
      "-s" "-w"
      "-X github.com/linkerd/linkerd2/pkg/version.Version=${src.rev}"
    ];

    nativeBuildInputs = [ installShellFiles ];

    postInstall = ''
      mv $out/bin/cli $out/bin/linkerd
      installShellCompletion --cmd linkerd \
        --bash <($out/bin/linkerd completion bash) \
        --zsh <($out/bin/linkerd completion zsh) \
        --fish <($out/bin/linkerd completion fish)
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      $out/bin/linkerd version --client | grep ${src.rev} > /dev/null
    '';

    meta = with lib; {
      description = "A simple Kubernetes service mesh that improves security, observability and reliability";
      downloadPage = "https://github.com/linkerd/linkerd2/";
      homepage = "https://linkerd.io/";
      license = licenses.asl20;
      maintainers = with maintainers; [ Gonzih bryanasdev000 superherointj ];
    };
  };
in
  {
    stable = generic {
      channel = "stable";
      version = "2.10.2";
      sha256 = "sha256-dOD0S4FJ2lXE+1VZooi8tKvC8ndGEHAxmAvSqoWI/m0=";
      vendorSha256 = "sha256-Qb0FZOvKL9GgncfUl538PynkYbm3V8Q6lUpApUoIp5s=";
    };
    edge = generic {
      channel = "edge";
      version = "21.9.3";
      sha256 = "0swqx4myvr24visj39icg8g90kj325pvf22bq447rnm0whq3cnyz";
      vendorSha256 = "sha256-fMtAR66TwMNR/HCVQ9Jg3sJ0XBx2jUKDG7/ts0lEZM4=";
    };
  }
