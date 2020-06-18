{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "tanka";
  version = "0.10.0";

  goPackagePath = "github.com/grafana/tanka";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "tanka";
    sha256 = "02nm56iyxvyfyz6l150nqqy9dsn5r03hvmjqm9xxvs2bqlqfpnqy";
  };

  subPackages = [ "cmd/tk" ];

  goDeps = ./deps.nix;

  meta = {
    description = "Flexible, reusable and concise configuration for Kubernetes";
    license = lib.licenses.asl20;
    homepage = "https://tanka.dev/";
    platforms = lib.platforms.unix;
  };
}
