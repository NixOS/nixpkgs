# Tests for v2 merge check coherence
{ lib, ... }:
let
  inherit (lib) types mkOption;

  # The problematic pattern: overriding check with //
  # This inner type should reject everything (check always returns false)
  adhocOverrideType = (types.lazyAttrsOf types.raw) // {
    check = _: false;
  };

  # Using addCheck is the correct way to add custom checks
  properlyCheckedType = types.addCheck (types.lazyAttrsOf types.raw) (v: v ? foo);

  # Using addCheck with a check that will fail
  failingCheckedType = types.addCheck (types.lazyAttrsOf types.raw) (v: v ? foo);

  # Ad-hoc override on outer type
  adhocOuterType = types.lazyAttrsOf types.int // {
    check = _: false;
  };

  # Ad-hoc override on left side of either
  adhocEitherLeft = types.lazyAttrsOf types.raw // {
    check = _: false;
  };

  # Ad-hoc override on coercedType in coercedTo
  adhocCoercedFrom = types.lazyAttrsOf types.raw // {
    check = _: false;
  };

  # Ad-hoc override on finalType in coercedTo
  adhocCoercedTo = types.lazyAttrsOf types.raw // {
    check = _: false;
  };

  # Ad-hoc override wrapped in addCheck
  adhocAddCheck = types.addCheck (types.lazyAttrsOf types.raw // { check = _: false; }) (v: true);
in
{
  # Test 1: Ad-hoc check override in nested type should be detected
  options.adhocFail = mkOption {
    type = types.lazyAttrsOf adhocOverrideType;
    default = { };
  };
  config.adhocFail = {
    foo = { };
  };

  # Test 1b: Ad-hoc check override in outer type should be detected
  options.adhocOuterFail = mkOption {
    type = adhocOuterType;
    default = { };
  };
  config.adhocOuterFail.bar = 42;

  # Test 1c: Ad-hoc check override on left side of either type
  options.eitherLeftFail = mkOption {
    type = types.either adhocEitherLeft types.int;
  };
  config.eitherLeftFail.foo = { };

  # Test 1d: Ad-hoc check override on right side of either type
  options.eitherRightFail = mkOption {
    type = types.either types.int (types.lazyAttrsOf types.raw // { check = _: false; });
  };
  config.eitherRightFail.foo = { };

  # Test 1e: Ad-hoc check override on coercedType in coercedTo
  options.coercedFromFail = mkOption {
    type = types.coercedTo adhocCoercedFrom (x: { bar = 1; }) (types.lazyAttrsOf types.int);
  };
  config.coercedFromFail = {
    foo = { };
  };

  # Test 1f: Ad-hoc check override on finalType in coercedTo
  options.coercedToFail = mkOption {
    type = types.coercedTo types.str (x: { }) adhocCoercedTo;
  };
  config.coercedToFail.foo = { };

  # Test 1g: Ad-hoc check override wrapped in addCheck
  options.addCheckNested = mkOption {
    type = adhocAddCheck;
  };
  config.addCheckNested.foo = { };

  # Test 2: Using addCheck should work correctly
  options.addCheckPass = mkOption {
    type = types.lazyAttrsOf properlyCheckedType;
    default = { };
  };
  config.addCheckPass.bar.foo = "value";

  # Test 3: addCheck should validate values properly
  options.addCheckFail = mkOption {
    type = types.lazyAttrsOf failingCheckedType;
    default = { };
  };
  config.addCheckFail.bar.baz = "value"; # Missing required 'foo' attribute

  # Test 4: Normal v2 types should work without coherence errors
  options.normalPass = mkOption {
    type = types.lazyAttrsOf (types.attrsOf types.int);
    default = { };
  };
  config.normalPass.foo.bar = 42;

  # Success assertion - only checks things that should succeed
  options.result = mkOption {
    type = types.bool;
    default = false;
  };
  config.result = true;
}
