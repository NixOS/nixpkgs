{
  crystal,
  fetchFromGitea,
  lib,
}:

crystal.buildCrystalPackage rec {
  pname = "exfetch";
  version = "1.3.5";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Izder456";
    repo = "exfetch";
    tag = version;
    hash = "sha256-Dw6NQBcPNpmLWClJ3uPBPPOF5WBMULAn2vEIl4ewkec=";
    fetchSubmodules = true;
  };

  buildPhase = "make";

  doCheck = false;

  meta = {
    description = "Shell-extensible fetching utility aiming to be a spiritual successor to crfetch, written in crystal";
    mainProgram = "exfetch";
    homepage = "https://codeberg.org/Izder456/exfetch";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ goose121 ];
  };
}
