{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "process-compose";
  version = "0.29.1";

  src = fetchFromGitHub {
    owner = "F1bonacc1";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FB0PjvPBfbytIXwYs+eT9PMnKX/yymrajlJ42FDlMFs=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-fL12Rx/0TF2jjciSHgfIDfrqdQxxm2JiGfgO3Dgz81M=";

  doCheck = false;

  postInstall = ''
    mv $out/bin/{src,process-compose}

    installShellCompletion --cmd process-compose \
      --bash <($out/bin/process-compose completion bash) \
      --zsh <($out/bin/process-compose completion zsh) \
      --fish <($out/bin/process-compose completion fish)
  '';

  meta = with lib; {
    description = "A simple and flexible scheduler and orchestrator to manage non-containerized applications";
    homepage = "https://github.com/F1bonacc1/process-compose";
    changelog = "https://github.com/F1bonacc1/process-compose/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ thenonameguy ];
  };
}
