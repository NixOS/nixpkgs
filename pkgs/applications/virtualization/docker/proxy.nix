{ stdenv, buildGoPackage, fetchFromGitHub, docker }:

buildGoPackage rec {
  name = "docker-proxy-${rev}";
  rev = "7b2b1feb1de4817d522cc372af149ff48d25028e";

  src = fetchFromGitHub {
    inherit rev;
    owner = "docker";
    repo = "libnetwork";
    sha256 = "1ng577k11cyv207bp0vaz5jjfcn2igd6w95zn4izcq1nldzp5935";
  };

  goPackagePath = "github.com/docker/libnetwork";

  goDeps = null;

  installPhase = ''
    install -m755 -D ./go/bin/proxy $bin/bin/docker-proxy
  '';

  meta = with stdenv.lib; {
    description = "Docker proxy binary to forward traffic between host and containers";
    license = licenses.asl20;
    homepage = https://github.com/docker/libnetwork;
    maintainers = with maintainers; [vdemeester];
    platforms = docker.meta.platforms;
  };
}
