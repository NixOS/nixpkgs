{ config, options, lib, ... }:
let
  inherit (lib) mkIf mkOption types;
in
{
  imports = [
    ../../modules/misc/assertions.nix
    (lib.mkRenamedOptionModule [ "machine" ] [ "nodes" "machine" ])
  ];

  options = {
  };

  config = {
  };
}
