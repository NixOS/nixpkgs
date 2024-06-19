{ lib, options, ... }:

let
  defs = lib.modules.mergeAttrDefinitionsWithPrio options._module.args;
  assertLazy = pos: throw "${pos.file}:${toString pos.line}:${toString pos.column}: The test must not evaluate this the assertLazy thunk, but it did. Unexpected strictness leads to unexpected errors and performance problems.";
in

{
  options.result = lib.mkOption { };
  config._module.args = {
    default = lib.mkDefault (assertLazy __curPos);
    regular = null;
    force = lib.mkForce (assertLazy __curPos);
    unused = assertLazy __curPos;
  };
  config.result =
    assert defs.default.highestPrio == (lib.mkDefault (assertLazy __curPos)).priority;
    assert defs.regular.highestPrio == lib.modules.defaultOverridePriority;
    assert defs.force.highestPrio == (lib.mkForce (assertLazy __curPos)).priority;
    true;
}
