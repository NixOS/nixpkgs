{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "process-compose";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "F1bonacc1";
    repo = pname;
    rev = "v${version}";
    sha256 = "7UVCGyFay0yQAcO1NKb1+vsNqX1v9Hf5NUgjnHlgnG0=";
  };

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "IsO1B6z1/HoGQ8xdNKQqZ/eZd90WikDbU9XiP0z28mU=";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ thenonameguy ];
  };
}
