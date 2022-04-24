{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "docker-proxy";
  version = "unstable-2020-12-15";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "libnetwork";
    rev = "fa125a3512ee0f6187721c88582bf8c4378bd4d7";
    sha256 = "1r47y0gww3j7fas4kgiqbhrz5fazsx1c6sxnccdfhj8fzik77s9y";
  };

  goPackagePath = "github.com/docker/libnetwork";

  installPhase = ''
    install -m755 -D ./go/bin/proxy $out/bin/docker-proxy
  '';

  meta = with lib; {
    description = "Docker proxy binary to forward traffic between host and containers";
    license = licenses.asl20;
    homepage = "https://github.com/docker/libnetwork";
    maintainers = with maintainers; [vdemeester];
    platforms = platforms.linux;
  };
}
