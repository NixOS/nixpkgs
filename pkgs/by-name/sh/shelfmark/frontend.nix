{
  buildNpmPackage,
  callPackage,
}:
let
  common = callPackage ./common.nix { };
in
buildNpmPackage {
  pname = "shelfmark-frontend";
  inherit (common) version;

  src = "${common.src}/src/frontend";

  npmDepsHash = "sha256-RAzotFGj0FGpfF7iyB5f2fdKFvMLcpJx142yplRwboU=";

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = common.meta // {
    description = "Shelfmark frontend";
  };
}
