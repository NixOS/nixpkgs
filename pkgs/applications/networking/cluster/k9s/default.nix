{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.24.6";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "sha256-uqtjAvtsF+4cz3M60Xj9sCNotaoPzaeeTKnXQUB4CIo=";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/k9s/cmd.version=${version}
      -X github.com/derailed/k9s/cmd.commit=${src.rev}
  '';

  vendorSha256 = "sha256-/4Aof09MYHPc4VJJV2EyB7T9zNFtYY4JeDGJi67FQic=";

  doCheck = false;

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih markus1189 ];
  };
}
