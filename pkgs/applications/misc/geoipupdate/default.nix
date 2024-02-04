{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-/iLWy3yKO34nnn5ygAewR036PzgUGIqdhXNK4fx3Ym8=";
  };

  vendorHash = "sha256-jW5/09sOUvPZVM1wzL4xg/a14kZ0KsM8e+zEQoADsl4=";

  ldflags = [ "-X main.version=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = teams.helsinki-systems.members;
  };
}
