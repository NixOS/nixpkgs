# Evaluate `release.nix' like Hydra would (i.e. call each job
# attribute with the expected `system' argument).  Too bad
# nix-instantiate can't to do this.

let

  lib = (import ../.. {}).lib;

  rel = removeAttrs (import ../../pkgs/top-level/release.nix) ["tarball"];

  maybe = x: let y = builtins.tryEval x; in if y.success then y.value else null;

  call = attrs: lib.flip lib.mapAttrs attrs
    (n: v: builtins.trace n (
      if builtins.isFunction v then maybe (v { system = "i686-linux"; })
      else if builtins.isAttrs v then call v
      else null
    ));

in call rel
