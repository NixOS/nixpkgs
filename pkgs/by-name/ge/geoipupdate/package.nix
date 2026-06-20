{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "geoipupdate";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ATvQLN5i2Wc+kGBPsF0z3LrfjHkeGhjp6cwtgPFLRGk=";
  };

  vendorHash = "sha256-0/F9jUaqWG6yn8ciXhzzTctQzw1EffsVIJiDLpWyHTQ=";

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  doCheck = false;

  meta = {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      das_j
      helsinki-Jo
    ];
    mainProgram = "geoipupdate";
  };
})
