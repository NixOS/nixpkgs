{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ory";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-dO595NzdkVug955dqji/ttAPb+sMGLxJftXHzHA37Lo=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  CGO_ENABLED = 1;

  tags = [
    "sqlite"
  ];

  vendorHash = "sha256-H1dM/r7gJvjnexQwlA4uhJ7rUH15yg4AMRW/f0k1Ixw=";

  postInstall = ''
    mv $out/bin/cli $out/bin/ory
    installShellCompletion --cmd ory \
      --bash <($out/bin/ory completion bash) \
      --fish <($out/bin/ory completion fish) \
      --zsh <($out/bin/ory completion zsh)
  '';

  meta = with lib; {
    mainProgram = "ory";
    description = "The Ory CLI";
    homepage = "https://www.ory.sh/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ luleyleo nicolas-goudry ];
  };
}
