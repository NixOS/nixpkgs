{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cntr";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = finalAttrs.version;
    sha256 = "sha256-SnOIJ6tDyILaQGpnAKbQCkz/MRFCZPhQKNWpoajI8S0=";
  };

  cargoHash = "sha256-cpSonMLATzWsCElvi4G1J9OA/FYa90I7SOelr+r+trk=";

  passthru.tests = nixosTests.cntr;

  meta = {
    description = "Container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mic92
      sigmasquadron
    ];
    mainProgram = "cntr";
  };
})
