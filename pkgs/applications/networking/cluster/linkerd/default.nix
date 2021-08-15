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
      version = "21.8.2";
      sha256 = "sha256-jMYJ/mLWvuje4ZRuRbzMaqhz8kyn1bYGITJxkyw5Fyg=";
      vendorSha256 = "sha256-18QB2GOxHfnP4GQaF0aohY5kEOg0xN/c+Sp33Ww/1uQ=";
    };
  }
