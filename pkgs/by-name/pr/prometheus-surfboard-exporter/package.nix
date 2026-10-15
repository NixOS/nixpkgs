{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "surfboard_exporter";
  version = "2.0.0";

  src = fetchFromGitHub {
    rev = finalAttrs.version;
    owner = "ipstatic";
    repo = "surfboard_exporter";
    hash = "sha256-/MbiupXgL3txqBmBpEu5NpfMuo3UKUs1p9wiYozQFYc=";
  };

  patches = [
    ./add-go-mod.patch
  ];

  vendorHash = null;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) surfboard; };

  meta = {
    description = "Arris Surfboard signal metrics exporter";
    mainProgram = "surfboard_exporter";
    homepage = "https://github.com/ipstatic/surfboard_exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
