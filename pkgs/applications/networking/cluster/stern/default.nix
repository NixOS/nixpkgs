{ stdenv, lib, buildPackages, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "stern";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${version}";
    sha256 = "sha256-86XoYzw1bnIWwGiFgRl9RcZSYrF4byYKnDlJ4QSqXV0=";
  };

  vendorHash = "sha256-LLVd9WB8ixH78CHYe0sS4sCDCD+6SQ7PxWr2MHiAOxI=";

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
    homepage = "https://github.com/stern/stern";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbode preisschild ];
  };
}
