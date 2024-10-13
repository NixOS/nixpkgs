{ lib }:

# This defines an algebra to express platform constraints using AND, OR and NOT
# which behave like boolean operators but for platform properties.
#
# Examples:
#
# with lib.meta.platform.constraints;
# OR [
#   isLinux
#   isDarwin
# ]
#
# with lib.meta.platform.constraints;
# AND [
#   (OR [
#     isLinux
#     isDarwin
#   ])
#   (OR [
#     isx86
#     isAarch
#   ])
#   (NOT isMusl)
# ]

{
  constraints =
    {
      OR = value: {
        __operation = "OR";
        inherit value;
      };
      AND = value: {
        __operation = "AND";
        inherit value;
      };
      NOT = value: {
        __operation = "NOT";
        value = [ value ]; # Also make this a list for simplicity
      };
    }
    # Put patterns in this set for convenient use
    // lib.systems.inspect.patterns
    # Platform patterns too. We can just do this because platforms (i.e. `hostPlatform`) have all of these
    # mashed together too.
    // lib.systems.inspect.platformPatterns;

  # Evaluates a platform constraints expression down into a boolean value
  # similar to how lib.meta.platformMatch performs checks a single constraint.
  # Because this uses lib.meta.platformMatch internally it supports the same set
  # of platform constraints.
  evalConstraints =
    platform: initialValue:
    let
      operations = {
        OR = lib.any lib.id;
        AND = lib.all lib.id;
        NOT = x: !(lib.head x); # We have a list with one value
      };
      platformMatch' = lib.meta.platformMatch platform;
      recurse =
        expression:
        if expression ? __operation then
          operations.${expression.__operation} (map recurse expression.value)
        else
          platformMatch' expression;
    in
    recurse initialValue;
}
