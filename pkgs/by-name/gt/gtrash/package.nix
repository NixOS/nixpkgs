{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gtrash";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "umlx5h";
    repo = "gtrash";
    rev = "v${version}";
    hash = "sha256-odvj0YY18aishVWz5jWcLDvkYJLQ97ZSGpumxvxui4Y=";
  };

  vendorHash = "sha256-JJA9kxNCtvfs51TzO7hEaS4UngBOEJuIIRIfHKSUMls=";

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
    description = "Trash CLI manager written in Go";
    homepage = "https://github.com/umlx5h/gtrash";
    changelog = "https://github.com/umlx5h/gtrash/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ umlx5h ];
    mainProgram = "gtrash";
  };
}
