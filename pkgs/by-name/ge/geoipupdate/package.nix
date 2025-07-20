{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "geoipupdate";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-ATvQLN5i2Wc+kGBPsF0z3LrfjHkeGhjp6cwtgPFLRGk=";
  };

  vendorHash = "sha256-0/F9jUaqWG6yn8ciXhzzTctQzw1EffsVIJiDLpWyHTQ=";

  ldflags = [ "-X main.version=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    teams = [ teams.helsinki-systems ];
    mainProgram = "geoipupdate";
  };
}
