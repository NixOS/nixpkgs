{ stdenv, lib, buildPackages, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "stern";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${version}";
    sha256 = "sha256-Lx5f2dqjdhgMXky1Pv2ik9i56ugsQmZK/ag4veC9Dac=";
  };

  vendorHash = "sha256-6jI/I7Nw/vJwKNvgH/35uHYu51SBX+WFH5s0WKfCqBo=";

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
