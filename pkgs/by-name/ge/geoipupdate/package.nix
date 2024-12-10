{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "geoipupdate";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "sha256-OWo8puUjzMZXZ80HMpCrvRGUVdclnSxk7rHR5egOU1Y=";
  };

  vendorHash = "sha256-MApZUtI9JewMBbImuV3vsNG89UvCfxcBg3TZiuk/nvg=";

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
