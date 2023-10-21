{ config, lib, pkgs, ... }:

let
  cfg = config.programs.distrobox;

  # Since it's in POSIX sh so we'll quote everything as much as possible.
  # Ideally, we'll go with single-quoted strings but this prevents dynamic
  # values with shell expansions.
  toDistroboxConf = lib.generators.toKeyValue {
    listsAsDuplicateKeys = false;
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = v:
        if v == true then "1"
        else if v == false then "0"
        else if lib.isString v then ''"${v}"''
        else if lib.isPath v then lib.escapeShellArg v
        else if lib.isList v then ''"${lib.concatStringsSep " " v}"''
        else lib.generators.mkValueStringDefault { } v;
    } "=";
  };

  distroboxConf = { }: {
    type = with lib.types;
      let
        valueType = (oneOf [
          bool
          float
          int
          path
          str
          (listOf valueType)
        ]) // {
          description = "Distrobox config value";
        };
      in
      attrsOf valueType;

    generate = name: value: pkgs.writeText name (toDistroboxConf value);
  };

  settingsFormat = distroboxConf { };

  settingsFile = pkgs.writeText "distrobox-settings" ''
    ${toDistroboxConf cfg.settings}
    ${cfg.extraConfig}
  '';
in
{
  meta.maintainers = with lib.maintainers; [ foo-dogsquared ];

  options.programs.distrobox = {
    enable = lib.mkEnableOption "Distrobox";

    package = lib.mkPackageOption pkgs "distrobox" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        System-wide settings for Distrobox to be generated at
        {file}`/etc/distrobox/distrobox.conf`.

        For more options, you could look at the list of variables and their
        default values from the source code of each Distrobox command [such as
        the ones from
        `distrobox-create`](https://github.com/89luca89/distrobox/blob/9309e1ebe5c70fd1f9b5286fd3a76f3e7bd995bd/distrobox-create#L48-L76).

        ::: {.note}
        You don't have surround the string values with double quotes since the
        module will add them for you.
        :::
      '';
      example = lib.literalExpression ''
        {
          container_additional_volumes = [
            "/nix/store:/nix/store:r"
            "/etc/profiles/per-user:/etc/profiles/per-user:r"
          ];

          container_image_default = "registry.opensuse.org/opensuse/distrobox-packaging:latest";
          container_command = "sh -norc";
          unshare_ipc = true;
          unshare_netns = true;
        }
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration to be appended to
        {file}`/etc/distrobox/distrobox.conf`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."distrobox/distrobox.conf".source = settingsFile;
  };
}
