{ lib, ... }:
# test framework doesn't do eval deeply for us, so here we go
let ds = x: lib.deepSeq x x;
in
{
  imports = [
    ({
      options._module.args.canMerge = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
      };
    })
    ({ _module.args.canMerge.a = "one"; })
    ({ _module.args.canMerge.b = "two"; })
    ({ canMerge, ... }: {
      options.result = lib.mkOption {
        default = ds (lib.attrValues canMerge);
      };
    })
  ];
}
