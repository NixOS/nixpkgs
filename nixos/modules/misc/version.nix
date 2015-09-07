{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    system.stateVersion = mkOption {
      type = types.str;
      default = config.system.nixosRelease;
      description = ''
        Every once in a while, a new NixOS release may change
        configuration defaults in a way incompatible with stateful
        data. For instance, if the default version of PostgreSQL
        changes, the new version will probably be unable to read your
        existing databases. To prevent such breakage, you can set the
        value of this option to the NixOS release with which you want
        to be compatible. The effect is that NixOS will option
        defaults corresponding to the specified release (such as using
        an older version of PostgreSQL).
      '';
    };

    system.nixosVersion = mkOption {
      internal = true;
      type = types.str;
      description = "NixOS version.";
    };

    system.nixosRelease = mkOption {
      readOnly = true;
      type = types.str;
      default = readFile "${toString pkgs.path}/.version";
      description = "NixOS release.";
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
      readOnly = true;
      type = types.str;
      description = "NixOS release code name.";
    };

    system.defaultChannel = mkOption {
      internal = true;
      type = types.str;
      default = https://nixos.org/channels/nixos-unstable;
      description = "Default NixOS channel to which the root user is subscribed.";
    };

  };

  config = {

    system.nixosVersion = mkDefault (config.system.nixosRelease + config.system.nixosVersionSuffix);

    system.nixosVersionSuffix =
      let suffixFile = "${toString pkgs.path}/.version-suffix"; in
      mkDefault (if pathExists suffixFile then readFile suffixFile else "pre-git");

    system.nixosRevision =
      let fn = "${toString pkgs.path}/.git-revision"; in
      mkDefault (if pathExists fn then readFile fn else "master");

    # Note: code names must only increase in alphabetical order.
    system.nixosCodeName = "Emu";

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
