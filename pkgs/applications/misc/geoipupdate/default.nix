{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "0lhz7i4lprsik3s41y19vphsyc29vz6cbxikmvkmy6xjn40khjfr";
  };

  vendorSha256 = "1f858k8cl0dgiw124jv0p9jhi9aqxnc3nmc7hksw70fla2nzjrv0";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ das_j ];
  };
}
