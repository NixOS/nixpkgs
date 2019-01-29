{ lib
, buildGoPackage
, fetchFromGitHub
, callPackage
}:
let
  list = import ./data.nix;

  toDrv = data:
    buildGoPackage rec {
      inherit (data) owner repo version sha256;
      name = "${repo}-${version}";
      goPackagePath = "github.com/${owner}/${repo}";
      subPackages = [ "." ];
      src = fetchFromGitHub {
        inherit owner repo sha256;
        rev = "v${version}";
      };
      

      # Terraform allow checking the provider versions, but this breaks
      # if the versions are not provided via file paths.
      postBuild = "mv go/bin/${repo}{,_v${version}}";
    };
in
  {
    gandi = callPackage ./gandi {};
    ibm = callPackage ./ibm {};
    libvirt = callPackage ./libvirt {};
  } // lib.mapAttrs (n: v: toDrv v) list
