{ stdenv, pkgs, lib }:

let
  nodePackages = import ./node-packages.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages."@solid/community-server".override {
  pname = "community-solid-server";
  meta = {
    description = "Community Solid Server: an open and modular implementation of the Solid specifications";
    homepage = "https://github.com/CommunitySolidServer/CommunitySolidServer";
    changelog = "https://github.com/CommunitySolidServer/CommunitySolidServer/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "community-solid-server";
    maintainers = with lib.maintainers; [ ivandimitrov8080 ];
  };
}
