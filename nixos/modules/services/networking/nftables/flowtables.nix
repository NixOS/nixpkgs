{lib, ...}: let
  inherit (lib) concatStringsSep mapAttrsToList mkBefore mkDefault mkOption;
  inherit (lib.types) attrsOf bool enum int lines nonEmptyListOf nullOr str submodule;
  inherit (import ./lib.nix lib) formatList' formatPriority indent;

  flowtableType = submodule ({
    config,
    name,
    ...
  }: {
    options = {
      enable = mkOption {
        default = true;
        description = "Whether to enable this flowtable.";
        type = bool;
      };

      name = mkOption {
        description = "The flowtable name.";
        type = str;
      };

      hook = mkOption {
        default = "ingress";
        description = "Chain hook";
        type = enum ["ingress"];
      };

      priorityBase = mkOption {
        default = null;
        description = "Sets the base value `priority` is relative to";
        type = nullOr (enum ["filter"]);
      };

      priority = mkOption {
        default = null;
        description = "Flowtable priority";
        type = nullOr int;
      };

      devices = mkOption {
        description = "Devices part of this flowtable";
        type = nonEmptyListOf str;
      };

      content = mkOption {
        default = "";
        description = "Content of this flowtable";
        internal = true;
        type = lines;
      };
    };

    config = {
      name = mkDefault name;

      content = ''
        hook ${config.hook} priority ${formatPriority config.priorityBase config.priority};
        devices = ${formatList' config.devices};
      '';
    };
  });

  tableExt = submodule ({
    config,
    name,
    ...
  }: {
    options = {
      flowtables = mkOption {
        default = {};
        description = "Flowtables in this table.";
        type = attrsOf flowtableType;
      };

      content = mkOption {};
    };

    config = {
      content = mkBefore (concatStringsSep "\n" (
        mapAttrsToList (
          k: v: ''
            flowtable ${k} {
            ${indent v.content}
            }
          ''
        )
        config.flowtables
      ));
    };
  });
in {
  options = {
    networking.nftables = {
      tables = mkOption {
        type = attrsOf tableExt;
      };
    };
  };
}
