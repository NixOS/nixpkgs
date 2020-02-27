{ lib
, buildGoPackage
, fetchFromGitHub
, callPackage
, Security
}:
let
  list = import ./data.nix;

  toDrv = data:
    buildGoPackage rec {
      inherit (data) owner repo rev version sha256;
      name = "${repo}-${version}";
      goPackagePath = "github.com/${owner}/${repo}";
      subPackages = [ "." ];
      src = fetchFromGitHub {
        inherit owner repo rev sha256;
      };


      # Terraform allow checking the provider versions, but this breaks
      # if the versions are not provided via file paths.
      postBuild = "mv go/bin/${repo}{,_v${version}}";
    };
in
  {
    elasticsearch = callPackage ./elasticsearch {
     inherit Security;
    };
    gandi = callPackage ./gandi {};
    ibm = callPackage ./ibm {};
    libvirt = callPackage ./libvirt {};
    lxd = callPackage ./lxd {};
    ansible = callPackage ./ansible {};
  } // lib.mapAttrs (n: v: toDrv v) list
