{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.21.7";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "1rw1vzxfjzklzdpcxz7mplvlmggavaym260s7vzvbgvd1snf38cb";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/k9s/cmd.version=${version}
      -X github.com/derailed/k9s/cmd.commit=${src.rev}
  '';

  vendorSha256 = "05rsbi40pihdh212d5zn6cchnkrqd6rsyl3vfsw77ksybwakrbf7";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style.";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih markus1189 ];
  };
}
