{ config, ... }:
{
  class = {
    "just" = "data";
  };
  a = "one";
  b = "two";
  meta = "meta";

  _module.args.result =
    let
      r = removeAttrs config [ "_module" ];
    in
    builtins.trace (builtins.deepSeq r r) (
      r == {
        a = "one";
        b = "two";
        class = {
          "just" = "data";
        };
        meta = "meta";
      }
    );
}
