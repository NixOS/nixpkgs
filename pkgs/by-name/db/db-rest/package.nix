{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
  nixosTests,
}:
buildNpmPackage rec {
  pname = "db-rest";
  version = "6.1.0";

  inherit nodejs;

  src = fetchFromGitHub {
    owner = "derhuerst";
    repo = "db-rest";
    rev = version;
    hash = "sha256-1iJ26l6C6GevNkoDVMztPHiH3YsutJa3xWAsfYvgR9U=";
  };

  npmDepsHash = "sha256-ELVVsysNjkXuX4i6i5P3irn6twVDu6YiPYqy2hbIlIs=";

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
