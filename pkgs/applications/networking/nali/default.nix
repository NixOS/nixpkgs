{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "nali";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    hash = "sha256-JIP0QX1okCfDj2Y6wZ5TaV3QH0WP3oU3JjaKK6vMfWY=";
  };

  vendorHash = "sha256-wIp/ShUddz+RIcsEuKWUfxsV/wNB2X1jZtIltBZ0ROM=";
  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;
  ldflags = [ "-s" "-w" "-X github.com/zu1k/nali/internal/constant.Version=${version}" ];

  postInstall = ''
    installShellCompletion --cmd nali \
      --bash <($out/bin/nali completion bash) \
      --fish <($out/bin/nali completion fish) \
      --zsh <($out/bin/nali completion zsh)
  '';

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist xyenon ];
  };
}
