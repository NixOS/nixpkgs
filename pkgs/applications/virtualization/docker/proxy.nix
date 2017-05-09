{ stdenv, lib, fetchFromGitHub, go, docker }:

with lib;

stdenv.mkDerivation rec {
  name = "docker-proxy-${rev}";
  rev = "7b2b1feb1de4817d522cc372af149ff48d25028e";

  src = fetchFromGitHub {
    inherit rev;
    owner = "docker";
    repo = "libnetwork";
    sha256 = "1ng577k11cyv207bp0vaz5jjfcn2igd6w95zn4izcq1nldzp5935";
  };

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p .gopath/src/github.com/docker
    ln -sf $(pwd) .gopath/src/github.com/docker/libnetwork
    GOPATH="$(pwd)/.gopath:$(pwd)/Godeps/_workspace" go build -ldflags="$PROXY_LDFLAGS" -o docker-proxy ./cmd/proxy
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp docker-proxy $out/bin
  '';

  meta = {
    description = "Docker proxy binary to forward traffic between host and containers";
    license = licenses.asl20;
    homepage = https://github.com/docker/libnetwork;
    maintainers = with maintainers; [vdemeester];
    platforms = docker.meta.platforms;
  };
}
