{ lib
, buildGoPackage
, fetchFromGitHub
, callPackage
, buildGo112Module
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
      # Version 0.7.0 fails to build with go 1.13 due to dependencies:
      #   verifying git.apache.org/thrift.git@v0.12.0/go.mod: git.apache.org/thrift.git@v0.12.0/go.mod: Get https://sum.golang.org/lookup/git.apache.org/thrift.git@v0.12.0: dial tcp: lookup sum.golang.org on [::1]:53: read udp [::1]:52968->[::1]:53: read: connection refused
      #   verifying github.com/hashicorp/terraform@v0.12.0/go.mod: github.com/hashicorp/terraform@v0.12.0/go.mod: Get https://sum.golang.org/lookup/github.com/hashicorp/terraform@v0.12.0: dial tcp: lookup sum.golang.org on [::1]:53: read udp [::1]:52968->[::1]:53: read: connection refused
      buildGoModule = buildGo112Module;
    };
    gandi = callPackage ./gandi {};
    ibm = callPackage ./ibm {};
    libvirt = callPackage ./libvirt {};
    lxd = callPackage ./lxd {};
    ansible = callPackage ./ansible {};
  } // lib.mapAttrs (n: v: toDrv v) list
