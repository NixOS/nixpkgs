{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gtrash";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "umlx5h";
    repo = "gtrash";
    rev = "v${version}";
    hash = "sha256-5+wcrU2mx/ZawMCSCU4xddMlMVpoIW/Duv7XqUVIDoo=";
  };

  vendorHash = "sha256-iWNuPxetYH9xJpf3WMoA5c50kII9DUpWvhTVSE1kSk0=";

  subPackages = [ "." ];

  # disabled because it is required to run on docker.
  doCheck = false;

  CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd gtrash \
      --bash <($out/bin/gtrash completion bash) \
      --fish <($out/bin/gtrash completion fish) \
      --zsh <($out/bin/gtrash completion zsh)
  '';

  meta = with lib; {
    description = "A Trash CLI manager written in Go";
    homepage = "https://github.com/umlx5h/gtrash";
    changelog = "https://github.com/umlx5h/gtrash/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ umlx5h ];
    mainProgram = "gtrash";
  };
}
