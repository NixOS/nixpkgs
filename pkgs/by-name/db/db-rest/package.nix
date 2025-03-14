{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_18,
  nix-update-script,
  nixosTests,
}:
buildNpmPackage rec {
  pname = "db-rest";
  version = "6.0.6";

  nodejs = nodejs_18;

  src = fetchFromGitHub {
    owner = "derhuerst";
    repo = "db-rest";
    rev = version;
    hash = "sha256-Rwy36hi5p/EDLBbfi1M0DEKD+2/eiJsqo0r2Et/3Oa4=";
  };

  npmDepsHash = "sha256-Drwmnu23PvrT/cw42hl+mu/S/Dn5nzybWGCDCUF7+R8=";

  preConfigure = ''
    patchShebangs ./build/index.js
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests = {
    inherit (nixosTests) db-rest;
  };

  meta = {
    description = "Clean REST API wrapping around the Deutsche Bahn API";
    homepage = "https://v6.db.transport.rest/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "db-rest";
  };
}
