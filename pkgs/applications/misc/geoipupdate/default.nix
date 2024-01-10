{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-Rm/W3Q5mb+qkrUYqWK83fi1FgO4KoL7+MjTuvhvY/qk=";
  };

  vendorHash = "sha256-YXybBVGCbdsP2pP7neHWI7KhkpE3tRo9Wpsx1RaEn9w=";

  ldflags = [ "-X main.version=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = teams.helsinki-systems.members;
  };
}
