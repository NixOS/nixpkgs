{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-nshQxr6y3TxKsAVSA9mzL7LJfCtpv0QuuTTqk3/lENc=";
  };

  vendorSha256 = "sha256-fqQWFhFeyW4GntRBxEeN6WSOo0G+1hH9vSEZmBKglz8=";

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ das_j ];
  };
}
