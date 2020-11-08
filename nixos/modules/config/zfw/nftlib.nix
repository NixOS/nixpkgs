{lib}:
with lib;
rec {
  priorityOption = {
    description = ''
      The priority of this rule. Rules with lower priority values
       will be processed later.
     '';
    type = types.int;
    default = 500;
  };

  ruleBaseOptions = {
    priority = mkOption priorityOption;
    rule = mkOption {
      description = "nftables rule";
      type = nestedListOf types.str;
    };
  };

  normalizeRule = {priority, rule, ...}: { inherit priority rule; };

  nestedListOf = type:
    let
      innerType = types.either (types.listOf innerType) type;
    in
      types.coercedTo type singleton innerType;
    
}
