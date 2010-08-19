# Evaluate `release.nix' like Hydra would (i.e. call each job
# attribute with the expected `system' argument).  Too bad
# nix-instantiate can't to do this.

let

  lib = (import ../.. {}).lib;

  rel = removeAttrs (import ../../pkgs/top-level/release.nix) [ "tarball" "xbursttools" ];

  seqList = xs: res: lib.fold (x: xs: lib.seq x xs) res xs;
  
  strictAttrs = as: seqList (lib.attrValues as) as;

  maybe = as: let y = builtins.tryEval (strictAttrs as); in if y.success then y.value else builtins.trace "FAIL" null;

  call = attrs: lib.flip lib.mapAttrs attrs
    (n: v: builtins.trace n (
      if builtins.isFunction v then maybe (v { system = "i686-linux"; })
      else if builtins.isAttrs v then call v
      else null
    ));

in call rel
