{ stdenv, lib, fetchFromGitHub, go, docker }:

with lib;

stdenv.mkDerivation rec {
  name = "docker-proxy-${rev}";
  rev = "0f534354b813003a754606689722fe253101bc4e";

  src = fetchFromGitHub {
    inherit rev;
    owner = "docker";
    repo = "libnetwork";
    sha256 = "1ah7h417llcq0xzdbp497pchb9m9qvjhrwajcjb0ybrs8v889m31";
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
