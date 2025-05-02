{ stdenv, lib, buildPackages, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "stern";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${version}";
    sha256 = "sha256-8Tvhul7GwVbRJqJenbYID8OY5zGzFhIormUwEtLE0Lw=";
  };

  vendorHash = "sha256-RLcF7KfKtkwB+nWzaQb8Va9pau+TS2uE9AmJ0aFNsik=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X github.com/stern/stern/cmd.version=${version}" ];

  postInstall = let
    stern = if stdenv.buildPlatform.canExecute stdenv.hostPlatform then "$out" else buildPackages.stern;
  in
    ''
      for shell in bash zsh; do
        ${stern}/bin/stern --completion $shell > stern.$shell
        installShellCompletion stern.$shell
      done
    '';

  meta = with lib; {
    description = "Multi pod and container log tailing for Kubernetes";
    mainProgram = "stern";
    homepage = "https://github.com/stern/stern";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbode preisschild ];
  };
}
