{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "argocd";
<<<<<<< HEAD
  version = "2.8.3";
=======
  version = "2.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-sVaUItort09n2aShrE0MqOKQps44qNQv0Nox4P21xqg=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-WeDIvw9KHDL5h/MQ9H1rOZkAlUOzROGw/gwpZB2jvOg=";
=======
    sha256 = "sha256-1P3FIgC9j0SbwzWo0aPUwVTKNlSY3FG7Iz6KD9pbv84=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-VRbNzJANWA7MjomzxNRK19Q4L+fsztMpumUbdYszYqw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Set target as ./cmd per cli-local
  # https://github.com/argoproj/argo-cd/blob/master/Makefile#L227
  subPackages = [ "cmd" ];

  ldflags =
    let package_url = "github.com/argoproj/argo-cd/v2/common"; in
    [
      "-s" "-w"
      "-X ${package_url}.version=${version}"
      "-X ${package_url}.buildDate=unknown"
      "-X ${package_url}.gitCommit=${src.rev}"
      "-X ${package_url}.gitTag=${src.rev}"
      "-X ${package_url}.gitTreeState=clean"
      "-X ${package_url}.kubectlVersion=v0.24.2"
      # NOTE: Update kubectlVersion when upgrading this package with
      # https://github.com/argoproj/argo-cd/blob/v${version}/go.mod#L95
      # Per https://github.com/argoproj/argo-cd/blob/master/Makefile#L18
      # Will need a way to automate it :P
    ];

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/cmd" -T $out/bin/argocd
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/argocd version --client | grep ${src.rev} > /dev/null
  '';

  postInstall = ''
    installShellCompletion --cmd argocd \
      --bash <($out/bin/argocd completion bash) \
      --zsh <($out/bin/argocd completion zsh)
  '';

  meta = with lib; {
    description = "Declarative continuous deployment for Kubernetes";
    downloadPage = "https://github.com/argoproj/argo-cd";
    homepage = "https://argo-cd.readthedocs.io/en/stable/";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ shahrukh330 bryanasdev000 qjoly ];
=======
    maintainers = with maintainers; [ shahrukh330 bryanasdev000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
