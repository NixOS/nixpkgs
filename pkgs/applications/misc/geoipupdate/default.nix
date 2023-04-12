{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "4.11.1";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-85xPXqvRfc6zip3tPcxFsE+niPmnnPqi9gLF+ioqbV8=";
  };

  vendorHash = "sha256-cPdQ7AIYUacoq885K8XBF+zChUPwbZ7YI4aDCIBOvMY=";

  ldflags = [ "-X main.version=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ das_j ];
  };
}
