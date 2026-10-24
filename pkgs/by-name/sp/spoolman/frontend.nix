{ buildNpmPackage, callPackage }:
let
  common = callPackage ./common.nix { };
in

buildNpmPackage {
  pname = "spoolman-frontend";

  inherit (common) version;

  src = "${common.src}/client";

  npmDepsHash = "sha256-Bjkdh3qRbibhj1zabCeHG306tX46AZB3ct3ki1iIuzE=";

  VITE_APIURL = "/api/v1";

  installPhase = "cp -r dist $out";

  meta = common.meta // {
    description = "Spoolman frontend";
  };
}
