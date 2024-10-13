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
let
  inherit (lib.meta) platformMatch;
  inherit (lib) any all;

in

rec {
  constraints =
    {
      OR = fns: platform: any (fn: fn platform) fns;
      AND = fns: platform: all (fn: fn platform) fns;
      NOT = fn: platform: !fn platform;
    }
    # Put patterns in this set for convenient use
    // lib.mapAttrs (_: makeConstraint) lib.systems.inspect.patterns
    # Platform patterns too. We can just do this because platforms (i.e. `hostPlatform`) have all of these
    # mashed together too.
    // lib.mapAttrs (_: makeConstraint) lib.systems.inspect.platformPatterns;

  makeConstraint = pattern: platform: platformMatch platform pattern;
}
