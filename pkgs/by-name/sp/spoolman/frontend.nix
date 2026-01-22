{ buildNpmPackage, callPackage }:
let
  common = callPackage ./common.nix { };
in

buildNpmPackage {
  pname = "spoolman-frontend";

  inherit (common) version;

  src = "${common.src}/client";

  npmDepsHash = "sha256-E4DvEOSHfwwM0C+vTRMDQbCNv2IDyFOFwfqszrI+uOA=";

  VITE_APIURL = "/api/v1";

  installPhase = "runHook preInstall; cp -r dist $out; runHook postInstall";

  meta = common.meta // {
    description = "Spoolman frontend";
    mainProgram = "spoolman-frontend";
  };
}
