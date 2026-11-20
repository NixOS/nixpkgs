{ buildNpmPackage, callPackage }:
let
  common = callPackage ./common.nix { };
in

buildNpmPackage {
  pname = "spoolman-frontend";

  inherit (common) version;

  src = "${common.src}/client";

  npmDepsHash = "sha256-8ojD7xMxRE9+b4O7vJdwKwrg8aYukYc3l+LF5enKFgA=";

  VITE_APIURL = "/api/v1";

  installPhase = "cp -r dist $out";

  meta = common.meta // {
    description = "Spoolman frontend";
    mainProgram = "spoolman-frontend";
  };
}
