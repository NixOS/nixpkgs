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
  # We assert that the new algorithmic way of generating these lists matches the
  # way they were hard-coded before.
  #
  # One might think "if we exhaustively test, what's the point of procedurally
  # calculating the lists anyway?". The answer is one can mindlessly update these
  # tests as new platforms become supported, and then just give the diff a quick
  # sanity check before committing :).

  (with lib.systems.doubles; {
    testall = mseteq all (
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
    );

    testarm = mseteq arm [
      "armv5tel-linux"
      "armv6l-linux"
      "armv6l-netbsd"
      "armv6l-none"
      "armv7a-linux"
      "armv7a-netbsd"
      "armv7l-linux"
      "armv7l-netbsd"
      "arm-none"
    ];
    testarmv7 = mseteq armv7 [
      "armv7a-linux"
      "armv7l-linux"
      "armv7a-netbsd"
      "armv7l-netbsd"
    ];
    testi686 = mseteq i686 [
      "i686-linux"
      "i686-freebsd"
      "i686-genode"
      "i686-netbsd"
      "i686-openbsd"
      "i686-cygwin"
      "i686-windows"
      "i686-none"
    ];
    testmips = mseteq mips [
      "mips-none"
      "mips64-none"
      "mips-linux"
      "mips64-linux"
      "mips64el-linux"
      "mipsel-linux"
      "mipsel-netbsd"
    ];
    testmmix = mseteq mmix [ "mmix-mmixware" ];
    testpower = mseteq power [
      "powerpc-linux"
      "powerpc-netbsd"
      "powerpc-none"
      "powerpc64-linux"
      "powerpc64le-linux"
      "powerpcle-none"
    ];
    testriscv = mseteq riscv [
      "riscv32-linux"
      "riscv64-linux"
      "riscv32-netbsd"
      "riscv64-netbsd"
      "riscv32-none"
      "riscv64-none"
    ];
    testriscv32 = mseteq riscv32 [
      "riscv32-linux"
      "riscv32-netbsd"
      "riscv32-none"
    ];
    testriscv64 = mseteq riscv64 [
      "riscv64-linux"
      "riscv64-netbsd"
      "riscv64-none"
    ];
    tests390x = mseteq s390x [
      "s390x-linux"
      "s390x-none"
    ];
    testx86_64 = mseteq x86_64 [
      "x86_64-linux"
      "x86_64-darwin"
      "x86_64-freebsd"
      "x86_64-genode"
      "x86_64-redox"
      "x86_64-openbsd"
      "x86_64-netbsd"
      "x86_64-cygwin"
      "x86_64-solaris"
      "x86_64-windows"
      "x86_64-none"
    ];

    testcygwin = mseteq cygwin [
      "i686-cygwin"
      "x86_64-cygwin"
    ];
    testdarwin = mseteq darwin [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    testfreebsd = mseteq freebsd [
      "aarch64-freebsd"
      "i686-freebsd"
      "x86_64-freebsd"
    ];
    testgenode = mseteq genode [
      "aarch64-genode"
      "i686-genode"
      "x86_64-genode"
    ];
    testredox = mseteq redox [ "x86_64-redox" ];
    testgnu = mseteq gnu linux; # ++ kfreebsd ++ ...
    testillumos = mseteq illumos [ "x86_64-solaris" ];
    testlinux = mseteq linux [
      "aarch64-linux"
      "armv5tel-linux"
      "armv6l-linux"
      "armv7a-linux"
      "armv7l-linux"
      "i686-linux"
      "loongarch64-linux"
      "m68k-linux"
      "microblaze-linux"
      "microblazeel-linux"
      "mips-linux"
      "mips64-linux"
      "mips64el-linux"
      "mipsel-linux"
      "powerpc-linux"
      "powerpc64-linux"
      "powerpc64le-linux"
      "riscv32-linux"
      "riscv64-linux"
      "s390-linux"
      "s390x-linux"
      "x86_64-linux"
    ];
    testnetbsd = mseteq netbsd [
      "aarch64-netbsd"
      "armv6l-netbsd"
      "armv7a-netbsd"
      "armv7l-netbsd"
      "i686-netbsd"
      "m68k-netbsd"
      "mipsel-netbsd"
      "powerpc-netbsd"
      "riscv32-netbsd"
      "riscv64-netbsd"
      "x86_64-netbsd"
    ];
    testopenbsd = mseteq openbsd [
      "i686-openbsd"
      "x86_64-openbsd"
    ];
    testwindows = mseteq windows [
      "aarch64-windows"
      "i686-windows"
      "x86_64-windows"
    ];
    testunix = mseteq unix (
      linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos ++ cygwin ++ redox
    );
  })

  // {
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
    test_toLosslessStringMaybe_fail = {
      expr = toLosslessStringMaybe (lib.systems.elaborate "x86_64-linux" // { something = "extra"; });
      expected = null;
    };
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
  }

  # Generate test cases to assert that a change in any non-function attribute makes a platform unequal
  //
    lib.concatMapAttrs
      (platformAttrName: origValue: {

        ${"test_equals_unequal_${platformAttrName}"} =
          let
            modified =
              assert origValue != arbitraryValue;
              lib.systems.elaborate "x86_64-linux" // { ${platformAttrName} = arbitraryValue; };
            arbitraryValue = x: "<<modified>>";
          in
          {
            expr = lib.systems.equals (lib.systems.elaborate "x86_64-linux") modified;
            expected =
              {
                # Changes in these attrs are not detectable because they're function.
                # The functions should be derived from the data, so this is not a problem.
                canExecute = null;
                emulator = null;
                emulatorAvailable = null;
                staticEmulatorAvailable = null;
                isCompatible = null;
              } ? ${platformAttrName};
          };

      })
      (
        lib.systems.elaborate "x86_64-linux" # arbitrary choice, just to get all the elaborated attrNames
      )

)
