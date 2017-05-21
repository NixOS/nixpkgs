let inherit (import ../attrsets.nix) mapAttrs; in

rec {
  doubles = import ./doubles.nix;
  parse = import ./parse.nix;
  inspect = import ./inspect.nix;
  platforms = import ./platforms.nix;

  # Elaborate a `localSystem` or `crossSystem` so that it contains everything
  # necessary.
  #
  # `parsed` is inferred from args, both because there are two options with one
  # clearly prefered, and to prevent cycles. A simpler fixed point where the RHS
  # always just used `final.*` would fail on both counts.
  elaborate = args: let
    final = {
      # Prefer to parse `config` as it is strictly more informative.
      parsed = parse.mkSystemFromString (if args ? config then args.config else args.system);
      # Either of these can be losslessly-extracted from `parsed` iff parsing succeeds.
      system = parse.doubleFromSystem final.parsed;
      config = parse.tripleFromSystem final.parsed;
      # Just a guess, based on `system`
      platform = platforms.selectBySystem final.system;
    } // mapAttrs (n: v: v final.parsed) inspect.predicates
      // args;
  in final;
}
