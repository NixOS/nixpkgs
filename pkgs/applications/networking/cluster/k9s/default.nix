{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.24.8";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "sha256-6RGm2uiYvsdpWdhNwDTw4z1O6uNErkWTuyOiwKIvXOY=";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/k9s/cmd.version=${version}
      -X github.com/derailed/k9s/cmd.commit=${src.rev}
  '';

  vendorSha256 = "sha256-lzxGTubm+qQes5QKaamfmSkXs4qquHHjIhts8YmKlYI=";

  doCheck = false;

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih markus1189 ];
  };
}
