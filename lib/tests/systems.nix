# Run:
# [nixpkgs]$ nix-instantiate --eval --strict lib/tests/systems.nix
# Expected output: [], or the failed cases
#
# OfBorg runs (approximately) nix-build lib/tests/release.nix
let
  lib = import ../default.nix;
  mseteq = x: y: {
    expr = lib.sort lib.lessThan x;
    expected = lib.sort lib.lessThan y;
  };

  platformsContaining = system: lib.attrNames (lib.filterAttrs (_: lib.elem system) lib.platforms);

  /*
    Try to convert an elaborated system back to a simple string. If not possible,
    return null. So we have the property:

        sys: _valid_ sys ->
          sys == elaborate (toLosslessStringMaybe sys)

    NOTE: This property is not guaranteed when `sys` was elaborated by a different
          version of Nixpkgs.
  */
  toLosslessStringMaybe =
    sys:
    if lib.isString sys then
      sys
    else if lib.systems.equals sys (lib.systems.elaborate sys.system) then
      sys.system
    else
      null;

in
lib.runTests (
  # Computing the lib.platforms lists is surprisingly expensive, since all 70+
  # system doubles needs to be first parsed into a system attribute, and then
  # filtered with matchAttrs to see whether they match linux, darwin, gnu, etc.
  #
  # We could just compute the platforms based on the doubles alone (if the
  # string ends in linux, it's a linux system). But this wouldn't work well for
  # complicated platforms like bigEndian. Instead, we choose to keep our complex
  # logic for generating the platforms, but preprocess it into a
  # `platforms/generated.json` file. Whenever we want to support a new system, we
  # just add it to the list of all systems in platforms/generate.nix, and then
  # regenerate the data.
  #
  {
    # The test below enforces that generating the platforms fresh gives exactly
    # the preprocessed platforms.
    test_platforms_match_generated = {
      expr = lib.platforms;
      expected = import ../platforms/generate.nix { inherit lib; };
    };

    # These tests compare the generated lists with each other rather than with
    # hand-written expectations, so adding a system doesn't require updating them.
    # For example, testall fails if a system ends up in no kernel list, or in two.
    testall =
      with lib.systems.doubles;
      mseteq all (
        linux
        ++ darwin
        ++ freebsd
        ++ openbsd
        ++ netbsd
        ++ illumos
        ++ wasi
        ++ windows
        ++ cygwin
        ++ embedded
        ++ mmix
        ++ js
        ++ genode
        ++ redox
        ++ uefi
      );
    testgnu = with lib.systems.doubles; mseteq gnu linux; # ++ kfreebsd ++ ...
    testunix =
      with lib.systems.doubles;
      mseteq unix (linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos ++ cygwin ++ redox);

    # These tests guard against broken generation logic that moves a
    # primary system into or out of a list erroneously.
    test_platforms_containing_x86_64-linux = {
      expr = platformsContaining "x86_64-linux";
      expected = [
        "all"
        "gnu"
        "linux"
        "littleEndian"
        "unix"
        "x86"
        "x86_64"
      ];
    };
    test_platforms_containing_aarch64-linux = {
      expr = platformsContaining "aarch64-linux";
      expected = [
        "aarch"
        "aarch64"
        "all"
        "gnu"
        "linux"
        "littleEndian"
        "unix"
      ];
    };
    test_platforms_containing_aarch64-darwin = {
      expr = platformsContaining "aarch64-darwin";
      expected = [
        "aarch"
        "aarch64"
        "all"
        "darwin"
        "littleEndian"
        "unix"
      ];
    };

    test_equals_example_x86_64-linux = {
      expr = lib.systems.equals (lib.systems.elaborate "x86_64-linux") (
        lib.systems.elaborate "x86_64-linux"
      );
      expected = true;
    };

    test_toLosslessStringMaybe_example_x86_64-linux = {
      expr = toLosslessStringMaybe (lib.systems.elaborate "x86_64-linux");
      expected = "x86_64-linux";
    };
    test_toLosslessStringMaybe_fail = (
      let
        baseSystem = lib.systems.elaborate "x86_64-linux";
      in
      {
        expr = toLosslessStringMaybe (
          baseSystem
          // {
            _withoutFunctions = baseSystem._withoutFunctions // {
              something = "extra";
            };
          }
        );
        expected = null;
      }
    );
    test_elaborate_config_over_system = {
      expr =
        (lib.systems.elaborate {
          config = "i686-unknown-linux-gnu";
          system = "x86_64-linux";
        }).system;
      expected = "i686-linux";
    };
    test_elaborate_config_over_parsed = {
      expr =
        (lib.systems.elaborate {
          config = "i686-unknown-linux-gnu";
          parsed = (lib.systems.elaborate "x86_64-linux").parsed;
        }).parsed.cpu.arch;
      expected = "i686";
    };
    test_elaborate_system_over_parsed = {
      expr =
        (lib.systems.elaborate {
          system = "i686-linux";
          parsed = (lib.systems.elaborate "x86_64-linux").parsed;
        }).parsed.cpu.arch;
      expected = "i686";
    };
    test_equals_reelaborate_overridden_platform = {
      expr =
        let
          base = lib.systems.elaborate "x86_64-linux";
        in
        lib.systems.equals base (
          lib.systems.elaborate (
            base
            // {
              useLLVM = true;
              linker = "lld";
            }
          )
        );
      expected = false;
    };
  }
  // {
    # equals.functionNames must list exactly the function-valued attrs of an
    # elaborated system, so that _withoutFunctions stays correct without
    # iterating.
    test_equals_functionNames_in_sync =
      let
        sys = lib.systems.elaborate "x86_64-linux";
        actual = lib.filter (n: builtins.isFunction sys.${n}) (builtins.attrNames sys);
        expected = lib.sort lib.lessThan lib.systems.functionNames;
      in
      {
        expr = lib.sort lib.lessThan actual;
        inherit expected;
      };
  }

  # Generate test cases to assert that a change in any non-function attribute makes a platform unequal
  // (
    let
      # arbitrary choice, just to get all the elaborated attrNames
      baseSystem = lib.systems.elaborate "x86_64-linux";
    in
    lib.concatMapAttrs (platformAttrName: origValue: {
      ${"test_equals_unequal_${platformAttrName}"} =
        let
          # lib.systems.equals only checks the subattrset
          modified =
            assert origValue != arbitraryValue;
            baseSystem
            // {
              _withoutFunctions = baseSystem._withoutFunctions // {
                ${platformAttrName} = arbitraryValue;
              };
            };
          arbitraryValue = x: "<<modified>>";
        in
        {
          expr = lib.systems.equals baseSystem modified;
          expected = false;
        };

    }) baseSystem
  )

)
