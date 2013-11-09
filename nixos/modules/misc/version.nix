{ config, pkgs, ... }:

with pkgs.lib;

{

  options = {

    system.nixosVersion = mkOption {
      internal = true;
      type = types.str;
      description = "NixOS version.";
    };

    system.nixosVersionSuffix = mkOption {
      internal = true;
      type = types.str;
      description = "NixOS version suffix.";
    };

    system.nixosRevision = mkOption {
      internal = true;
      type = types.str;
      description = "NixOS Git revision hash.";
    };

    system.nixosCodeName = mkOption {
      internal = true;
      type = types.str;
      description = "NixOS release code name.";
    };

    system.defaultChannel = mkOption {
      internal = true;
      type = types.str;
      default = https://nixos.org/channels/nixos-13.10;
      description = "Default NixOS channel to which the root user is subscribed.";
    };

  };

  config = {

    system.nixosVersion =
      mkDefault (readFile "${toString pkgs.path}/.version" + config.system.nixosVersionSuffix);

    system.nixosVersionSuffix =
      let suffixFile = "${toString pkgs.path}/.version-suffix"; in
      mkDefault (if pathExists suffixFile then readFile suffixFile else "pre-git");

    system.nixosRevision =
      let fn = "${toString pkgs.path}/.git-revision"; in
      mkDefault (if pathExists fn then readFile fn else "master");

    # Note: code names must only increase in alphabetical order.
    system.nixosCodeName = "Baboon";

    # Generate /etc/os-release.  See
    # http://0pointer.de/public/systemd-man/os-release.html for the
    # format.
    environment.etc."os-release".text =
      ''
        NAME=NixOS
        ID=nixos
        VERSION="${config.system.nixosVersion} (${config.system.nixosCodeName})"
        VERSION_ID="${config.system.nixosVersion}"
        PRETTY_NAME="NixOS ${config.system.nixosVersion} (${config.system.nixosCodeName})"
        HOME_URL="http://nixos.org/"
      '';

  };

}
