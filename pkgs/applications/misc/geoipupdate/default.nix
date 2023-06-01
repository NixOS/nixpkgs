{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-n32HxXNk/mHYL6Dn3c8jmTIwrwOfyyd/dui1Uw/xf90=";
  };

  vendorHash = "sha256-t6uhFvuR54Q4nYur/3oBzAbBTaIjzHfx7GeEk6X/0os=";

  ldflags = [ "-X main.version=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ das_j ];
  };
}
