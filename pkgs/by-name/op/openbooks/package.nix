{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
}:
let
  common = callPackage ./common.nix { };

  frontend = callPackage ./frontend.nix { };
in
buildGoModule (finalAttrs: {
  pname = "openbooks";
  inherit (common) version src;

  vendorHash = "sha256-ETN5oZanDH7fOAVnfIHIoXyVof7CfEMkPSOHF2my5ys=";

  postPatch = ''
    cp -r ${finalAttrs.passthru.frontend} server/app/dist/
  '';

  subPackages = [ "cmd/openbooks" ];

  passthru = {
    inherit frontend;

    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = "Search and Download eBooks";
    mainProgram = "openbooks";
  };
})
