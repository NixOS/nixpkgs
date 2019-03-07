{ lib
, buildGoPackage
, fetchFromGitHub
, callPackage
}:
let
  list = import ./data.nix;

  # a generic plugin builder
  mkTerraformProvider = callPackage ./generic.nix {};

  toDrv = data:
    let
      inherit (data) owner repo version sha256;
    in
      mkTerraformProvider {
        pname = repo;
        version = version;
        goPackagePath = "github.com/${owner}/${repo}";
        src = fetchFromGitHub {
          inherit owner repo sha256;
          rev = "v${version}";
        };
      };
in
  {
    inherit mkTerraformProvider;
    gandi = callPackage ./gandi { inherit mkTerraformProvider; };
    ibm = callPackage ./ibm { inherit mkTerraformProvider; };
    libvirt = callPackage ./libvirt { inherit mkTerraformProvider; };
  } // lib.mapAttrs (n: v: toDrv v) list
