# Evaluate `release.nix' like Hydra would (i.e. call each job
# attribute with the expected `system' argument).  Too bad
# nix-instantiate can't to do this.

with import ../../pkgs/lib;

let
  trace = if builtins.getEnv "VERBOSE" == "1" then builtins.trace else (x: y: y);

  rel = removeAttrs (import ../../pkgs/top-level/release.nix) [ "tarball" "xbursttools" ];

  seqList = xs: res: fold (x: xs: seq x xs) res xs;
  
  strictAttrs = as: seqList (attrValues as) as;

  maybe = as: let y = builtins.tryEval (strictAttrs as); in if y.success then y.value else builtins.trace "FAIL" {};

  call = attrs: flip mapAttrs attrs
    (n: v: trace n (
      if builtins.isFunction v then maybe (v { system = "x86_64-linux"; })
      else if builtins.isAttrs v then call v
      else null
    ));

  # Add the ‘recurseForDerivations’ attribute to ensure that
  # nix-instantiate recurses into nested attribute sets.
  recurse = attrs:
    if isDerivation attrs
    then attrs
    else { recurseForDerivations = true; } // mapAttrs (n: v: recurse v) attrs;

in recurse (call rel)
