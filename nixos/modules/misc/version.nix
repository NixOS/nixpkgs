{ config, pkgs, ... }:

with pkgs.lib;

{

  options = {

    system.nixosVersion = mkOption {
      type = types.uniq types.string;
      description = "NixOS version.";
    };

    system.nixosVersionSuffix = mkOption {
      type = types.uniq types.string;
      description = "NixOS version suffix.";
    };

    system.nixosCodeName = mkOption {
      type = types.uniq types.string;
      description = "NixOS release code name.";
    };

  };

  config = {

    system.nixosVersion =
      mkDefault (builtins.readFile "${toString pkgs.path}/.version" + config.system.nixosVersionSuffix);

    system.nixosVersionSuffix =
      let suffixFile = "${toString pkgs.path}/.version-suffix"; in
      mkDefault (if builtins.pathExists suffixFile then builtins.readFile suffixFile else "pre-git");

    # Note: code names must only increase in alphabetical order.
    system.nixosCodeName = "Aardvark";

    # Generate /etc/os-release.  See
    # http://0pointer.de/public/systemd-man/os-release.html for the
    # format.
    environment.etc = singleton
      { source = pkgs.writeText "os-release"
          ''
            NAME=NixOS
            ID=nixos
            VERSION="${config.system.nixosVersion} (${config.system.nixosCodeName})"
            VERSION_ID="${config.system.nixosVersion}"
            PRETTY_NAME="NixOS ${config.system.nixosVersion} (${config.system.nixosCodeName})"
            HOME_URL="http://nixos.org/"
          '';
        target = "os-release";
      };

  };

}
