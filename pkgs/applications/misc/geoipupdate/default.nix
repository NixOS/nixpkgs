{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-fcz1g17JR6jOpq5zOpCmnI00hyXSYYGHfoFRE8/c8dk=";
  };

  vendorSha256 = "sha256-YawWlPZV4bBOsOFDo2nIXKWwcxb5hWy5OiB99MG0HcY=";

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ das_j ];
  };
}
