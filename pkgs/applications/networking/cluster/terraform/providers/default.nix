{ stdenv, lib, buildGoPackage, fetchFromGitHub }:
let
  list = import ./data.nix;
  toDrv = _: data:
    buildGoPackage rec {
      inherit (data) pname version;
      name = "${pname}-${version}";
      goPackagePath = "github.com/${data.src.owner}/${data.src.repo}";
      src = fetchFromGitHub data.src;
    };
in
  lib.mapAttrs toDrv list
