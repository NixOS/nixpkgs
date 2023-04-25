{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-jes4MWJh0y5ddWjU/Hp6xwZU7/HUi/q0vF5AYQRBKiE=";
  };

  vendorHash = "sha256-OnByMNjs6C3R7v5PRDYGYekamsesz9yq2KNsI+NHcQ4=";

  ldflags = [ "-X main.version=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ das_j ];
  };
}
