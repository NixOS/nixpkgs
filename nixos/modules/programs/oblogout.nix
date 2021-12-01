{ config, lib, pkgs, ... }:

with lib;

{

  imports = [
    (mkRemovedOptionModule [ "programs" "oblogout" ] "programs.oblogout has been removed from NixOS. This is because the oblogout repository has been archived upstream.")
  ];

}
