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
    sha256 = "11qms26648nwlwslnaflinxcr5rnp55s908rm1qpnbz0jnxf5ipw";
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
