{ buildNpmPackage, callPackage }:
let
  common = callPackage ./common.nix { };
in

buildNpmPackage {
  pname = "spoolman-frontend";

  inherit (common) version;

  src = "${common.src}/client";

  npmDepsHash = "sha256-+DDG0/T31xNcuBQprwmgjtGWsdxGkxFln0dekL0HT2Q=";

  VITE_APIURL = "/api/v1";

  installPhase = "cp -r dist $out";

  meta = common.meta // {
    description = "Spoolman frontend";
    mainProgram = "spoolman-frontend";
  };
}
