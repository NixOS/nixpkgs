{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "geoipupdate";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-XfQ5W2JbPBIAh5iF4jj9UJ4eLhhRHRwFPs0VWrBQVNA=";
  };

  vendorHash = "sha256-XQTZITuG9HjHnpYsSdwNLbdeDhH48+1kLCK32DMkppo=";

  ldflags = [ "-X main.version=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = teams.helsinki-systems.members;
    mainProgram = "geoipupdate";
  };
}
