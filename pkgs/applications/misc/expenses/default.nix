{ lib
, buildGoModule
, fetchFromGitHub
, sqlite
, installShellFiles
}:

buildGoModule rec {
  pname = "expenses";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "expenses";
    rev = "v${version}";
    sha256 = "sha256-sqsogF2swMvYZL7Kj+ealrB1AAgIe7ZXXDLRdHL6Q+0=";
  };

  vendorSha256 = "sha256-rIcwZUOi6bdfiWZEsRF4kl1reNPPQNuBPHDOo7RQgYo=";

  # package does not contain any tests as of v0.2.3
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ sqlite ];

  ldflags = [
    "-s" "-w" "-X github.com/manojkarthick/expenses/cmd.Version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd expenses \
      --bash <($out/bin/expenses completion bash) \
      --zsh <($out/bin/expenses completion zsh) \
      --fish <($out/bin/expenses completion fish)
  '';

  meta = with lib; {
   description = "An interactive command line expense logger";
   license = licenses.mit;
   maintainers = [ maintainers.manojkarthick ];
  };
}
