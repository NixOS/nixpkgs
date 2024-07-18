{
  config,
  lib,
  ...
}: let
  inherit (lib) attrValues concatMapStringsSep concatStringsSep filter genList head id length mapAttrsToList mkDefault mkEnableOption mkMerge mkOption mkOrder pipe singleton sortOn tail zipLists;
  inherit (lib.types) attrsOf bool enum int lines listOf nullOr str submodule;
  inherit (import ./lib.nix lib) formatPriority indent strLines flatMap flatMapAttrsToList;

  indices = l: genList id (length l);
  enumerate = l: zipLists (indices l) l;

  formatRule = {components, ...}: let
    addEscapes = l:
      (map (v:
        if v.fst != length components - 1
        then ''${v.snd} \''
        else v.snd)) (enumerate l);
    indent = l: [(head l)] ++ map (v: "  ${v}") (tail l);
  in
    pipe components [
      addEscapes
      (flatMap strLines)
      indent
      (concatStringsSep "\n")
    ];

  namedRuleType = submodule {
    options = {
      enable = mkEnableOption "this rule";

      order = mkOption {
        default = 1000;
        description = "Determines order of rules in the chain. Rules with lower values get put further at the beginning of the chain.";
        type = int;
      };
    };
  };

  ruleType = submodule ({config, ...}: {
    options = {
      components = mkOption {
        default = [];
        description = "Rule components";
        example = [
          ''iifname lo''
          ''accept''
          ''comment "Allow traffic from ourselves"''
        ];
        type = listOf str;
      };
    };
  });

  chainType = submodule ({
    config,
    name,
    options,
    ...
  }: {
    options = {
      enable = mkOption {
        default = true;
        description = "Whether to enable this chain.";
        type = bool;
      };

      name = mkOption {
        description = "The chain name.";
        type = str;
      };

      type = mkOption {
        description = "Chain type";
        type = enum ["filter" "nat" "route"];
      };

      hook = mkOption {
        description = "Chain hook";
        type = enum ["prerouting" "input" "output" "postrouting" "forward"];
      };

      priorityBase = mkOption {
        default = null;
        description = "Sets the base value `priority` is relative to";
        type = nullOr (enum ["raw" "mangle" "dstnat" "filter" "security" "out" "srcnat"]);
      };

      priority = mkOption {
        default = null;
        description = "Chain priority";
        type = nullOr int;
      };

      policy = mkOption {
        default = "accept";
        description = "Policy for packets not explicitly matched in a rule";
        type = enum ["accept" "drop"];
      };

      comment = mkOption {
        default = "";
        description = "Chain comment";
        type = str;
      };

      namedRules = mkOption {
        default = {};
        description = "Named rules";
        type = attrsOf (options.rules.type.nestedTypes.elemType.typeMerge namedRuleType.functor);
      };

      rules = mkOption {
        default = [];
        description = "Rules in this chain";
        type = listOf ruleType;
      };

      content = mkOption {
        default = "";
        description = "Content of this chain";
        internal = true;
        type = lines;
      };
    };

    config = {
      name = mkDefault name;

      rules = pipe config.namedRules [
        attrValues
        (filter (v: v.enable))
        (sortOn (v: v.order))
        (map ({order, ...} @ v: mkOrder order (removeAttrs v ["enable" "order"])))
        mkMerge
      ];

      content = mkMerge [
        (mkOrder 250 "type ${config.type} hook ${config.hook} priority ${formatPriority config.priorityBase config.priority}; policy ${config.policy};")
        (concatMapStringsSep "\n" formatRule config.rules)
      ];
    };
  });

  tableExt = submodule ({config, ...}: {
    options = {
      chains = mkOption {
        default = {};
        description = "Chains in this table.";
        type = attrsOf chainType;
      };
    };

    config = {
      content = mkMerge (
        mapAttrsToList (
          k: v: ''
            chain ${k} {
            ${indent v.content}
            }
          ''
        )
        config.chains
      );
    };
  });

  cfg = config.networking.nftables;
in {
  options = {
    networking.nftables = {
      tables = mkOption {
        type = attrsOf tableExt;
      };
    };
  };

  config = {
    assertions =
      flatMapAttrsToList
      (tableName: table:
        flatMapAttrsToList (chainName: chain:
          map (rule: {
            assertion = rule.expressions != [];
            message = "nftables rule must not be empty";
          })
          chain.rules
          ++ singleton {
            assertion = chain.priorityBase != null || chain.priority != null;
            message = "At least one of `priorityBase' and `priority' in `networking.nftables.tables.${tableName}.chains.${chainName}' must be non-null";
          })
        table.chains)
      cfg.tables;
  };
}
