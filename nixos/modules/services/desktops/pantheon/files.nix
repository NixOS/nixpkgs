# pantheon files daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  imports = [
    (mkRemovedOptionModule [ "services" "pantheon" "files" "enable" ] "Use `environment.systemPackages [ pkgs.pantheon.elementary-files ];`")
  ];

}
