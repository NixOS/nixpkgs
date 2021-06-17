{config, lib, packages, ...}:

with lib;

let
  nftlib = import ./nftlib.nix {inherit lib;};
  cfg = config.networking.nftables;
  
  sortRules = sort (a: b: a.priority > b.priority);

  indentLol = indent: lol:
      let
        indent' = prefix: list:
          if isNull list then
            null
          else if isString list then
            prefix + list
          else
            map (indent' (prefix + indent)) list;
      in
        map (indent' "") lol;


  processChain = name: chain:
    let
      hookStr =
        if !isNull chain.hook then
          let
            inherit (chain.hook) hook policy type priority;
            policyStr = if !isNull policy
                        then " policy ${chain.hook.policy};"
                        else "";
          in
            "type ${type} hook ${hook} priority ${priority};" + policyStr
        else
          null;

      getRuleText = {rule, ...}:
        if isList rule then
          rule
        else
          [ rule ];
      
      rules = concatMap getRuleText (sortRules chain.rules);
    in [
      "chain ${name} {"
      [ hookStr ]
      rules
      "}"
    ];
  
  tableChains = table: concatLists (mapAttrsToList processChain table.chains);
  
  processTable = family: name: table:
    [
      "table ${family} ${name} {"
      (tableChains table)
      "}"
    ];

  processFamily = family: tables:
    concatLists (mapAttrsToList (processTable family) tables);

  rulesetLol = concatLists (mapAttrsToList processFamily cfg.tables);

  ruleset = concatStringsSep "\n"
    (filter (x: ! isNull x)
      (flatten
        (indentLol "\t" rulesetLol)));
  
in {
  options.networking.nftables =
    with types;
    {
      tables = mkOption {
        description = "An nftables table. The names of these should be the address type";

        default = {};
        type = attrsOf ( attrsOf (submodule {

          options = {
            chains = mkOption {
              description = "The chains that go in this table";

              type = attrsOf (submodule {
                options = {
                  hook = mkOption {
                    description = "Options for a base chain";

                    default = null;
                    
                    type = nullOr (submodule {
                      options = {
                        hook = mkOption {
                          type = enum [
                            "prerouting"
                            "input"
                            "forward"
                            "output"
                            "postrouting"
                            "ingress"
                          ];
                        };

                        type = mkOption {
                          description = "Base chain type";

                          type = enum [ "filter" "nat" "route" ];
                        };

                        priority = mkOption {
                          type = coercedTo int toString str;
                          default = 0;
                        };

                        policy = mkOption {
                          description = "Default verdict for this chain";
                          type = nullOr (enum ["accept" "drop"]);
                          default = null;
                        };
                      };
                    });
                  }; # End of hook options
                  
                  rules = mkOption {
                    default = [];
                    type = listOf (submodule { options = nftlib.ruleBaseOptions; });
                  };
                };
              });
            };
          };
        }));
      };
    };

  config.networking.nftables.ruleset = ruleset;
}
