{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "humioctl";
  version = "0.32.3";

  src = fetchFromGitHub {
    owner = "humio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-MaBJL/3TZYmXjwt5/WmBBTXVhlJ6oyCgm+Lb8id6J3c=";
  };

  vendorHash = "sha256-FAy0LNmesEDgS3JTz5DPd8vkR5CHHhAbms++N8TQApA=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd humioctl \
      --bash <($out/bin/humioctl completion bash) \
      --zsh <($out/bin/humioctl completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/humio/cli";
    description = "A CLI for managing and sending data to Humio";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
