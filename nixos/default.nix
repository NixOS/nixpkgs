{ lib ? import ../lib
, configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" <nixos-config>

# to cross compile using the local machine as the buildPlatform, you
# only need to set `host` (you don't need to set `build`)
, build ? if host != null then builtins.currentSystem else null
, host ? null

# If you set `system` then nixpkgs will use that value as *both* the
# `build` *and* the `host`.  The only time you want this is if you
# have remote builders belonging to a different platform and you
# want them to do native builds for that platform.  In general using
# `build` and `host` provides more intuitive behavior, and you must
# use those (rather than `system`) if you want to cross compile.
, system ? if host==null && build==null then builtins.currentSystem else null
}:

let

  eval = import ./lib/eval-config.nix {
    inherit system;
    modules = [
      configuration
    ] ++ lib.optionals (build != null) [
      { nixpkgs.buildPlatform = lib.mkDefault build; }
    ] ++ lib.optionals (host != null || build != null) [
      { nixpkgs.hostPlatform = lib.mkDefault (if host==null then build else host); }
    ];
  };

in

{
  inherit (eval) pkgs config options;

  system = eval.config.system.build.toplevel;

  inherit (eval.config.system.build) vm vmWithBootLoader;
}
