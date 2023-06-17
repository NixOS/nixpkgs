{ stdenv, lib, buildPackages, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "stern";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${version}";
    sha256 = "sha256-E4Hs9FH+6iQ7kv6CmYUHw9HchtJghMq9tnERO2rpL1g=";
  };

  vendorHash = "sha256-+B3cAuV+HllmB1NaPeZitNpX9udWuCKfDFv+mOVHw2Y=";

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
    platforms = platforms.unix;
  };
}
