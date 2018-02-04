{ stdenv, lib, buildGoPackage, fetchFromGitHub }:
let
  list = import ./data.nix;

  toDrv = data:
    buildGoPackage rec {
      inherit (data) owner repo version sha256;
      name = "${repo}-${version}";
      goPackagePath = "github.com/${owner}/${repo}";
      src = fetchFromGitHub {
        inherit owner repo sha256;
        rev = "v${version}";
      };
    };

  maybeDrv = name: data:
    # azure-classic is an archived repo
    if name == "azure-classic" then null
    else toDrv data;
in
  lib.mapAttrs maybeDrv list
