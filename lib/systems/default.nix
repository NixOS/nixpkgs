{ lib }:
  let inherit (lib.attrsets) mapAttrs; in

rec {
  doubles = import ./doubles.nix { inherit lib; };
  parse = import ./parse.nix { inherit lib; };
  inspect = import ./inspect.nix { inherit lib; };
  platforms = import ./platforms.nix { inherit lib; };
  examples = import ./examples.nix { inherit lib; };

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
      # Derived meta-data
      libc =
        /**/ if final.isDarwin              then "libSystem"
        else if final.isMinGW               then "msvcrt"
        else if final.isMusl                then "musl"
        else if final.isAndroid             then "bionic"
        else if final.isLinux /* default */ then "glibc"
        # TODO(@Ericson2314) think more about other operating systems
        else                                     "native/impure";
      extensions = {
        sharedLibrary =
          /**/ if final.isDarwin  then ".dylib"
          else if final.isWindows then ".dll"
          else                         ".so";
        executable =
          /**/ if final.isWindows then ".exe"
          else                         "";
      };
      # Misc boolean options
      useAndroidPrebuilt = false;
    } // mapAttrs (n: v: v final.parsed) inspect.predicates
      // args;
  in assert final.useAndroidPrebuilt -> final.isAndroid;
    final;
}
