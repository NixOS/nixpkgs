# Run:
# [nixpkgs]$ nix-instantiate --eval --strict lib/tests/systems.nix
# Expected output: [], or the failed cases
#
# OfBorg runs (approximately) nix-build lib/tests/release.nix
let
  lib = import ../default.nix;
  mseteq = x: y: {
    expr     = lib.sort lib.lessThan x;
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
  toLosslessStringMaybe = sys:
    if lib.isString sys then sys
    else if lib.systems.equals sys (lib.systems.elaborate sys.system) then sys.system
    else null;

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
  testall = mseteq all (linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos ++ wasi ++ windows ++ embedded ++ mmix ++ js ++ genode ++ redox);

  testarm = mseteq arm [ "armv5tel-linux" "armv6l-linux" "armv6l-netbsd" "armv6l-none" "armv7a-linux" "armv7a-netbsd" "armv7l-linux" "armv7l-netbsd" "arm-none" "armv7a-darwin" ];
  testarmv7 = mseteq armv7 [ "armv7a-darwin" "armv7a-linux" "armv7l-linux" "armv7a-netbsd" "armv7l-netbsd" ];
  testi686 = mseteq i686 [ "i686-linux" "i686-freebsd" "i686-genode" "i686-netbsd" "i686-openbsd" "i686-cygwin" "i686-windows" "i686-none" "i686-darwin" ];
  testmips = mseteq mips [ "mips-none" "mips64-none" "mips-linux" "mips64-linux" "mips64el-linux" "mipsel-linux" "mipsel-netbsd" ];
  testmmix = mseteq mmix [ "mmix-mmixware" ];
  testpower = mseteq power [ "powerpc-netbsd" "powerpc-none" "powerpc64-linux" "powerpc64le-linux" "powerpcle-none" ];
  testriscv = mseteq riscv [ "riscv32-linux" "riscv64-linux" "riscv32-netbsd" "riscv64-netbsd" "riscv32-none" "riscv64-none" ];
  testriscv32 = mseteq riscv32 [ "riscv32-linux" "riscv32-netbsd" "riscv32-none" ];
  testriscv64 = mseteq riscv64 [ "riscv64-linux" "riscv64-netbsd" "riscv64-none" ];
  tests390x = mseteq s390x [ "s390x-linux" "s390x-none" ];
  testx86_64 = mseteq x86_64 [ "x86_64-linux" "x86_64-darwin" "x86_64-freebsd" "x86_64-genode" "x86_64-redox" "x86_64-openbsd" "x86_64-netbsd" "x86_64-cygwin" "x86_64-solaris" "x86_64-windows" "x86_64-none" ];

  testcygwin = mseteq cygwin [ "i686-cygwin" "x86_64-cygwin" ];
  testdarwin = mseteq darwin [ "x86_64-darwin" "i686-darwin" "aarch64-darwin" "armv7a-darwin" ];
  testfreebsd = mseteq freebsd [ "aarch64-freebsd" "i686-freebsd" "x86_64-freebsd" ];
  testgenode = mseteq genode [ "aarch64-genode" "i686-genode" "x86_64-genode" ];
  testredox = mseteq redox [ "x86_64-redox" ];
  testgnu = mseteq gnu (linux /* ++ kfreebsd ++ ... */);
  testillumos = mseteq illumos [ "x86_64-solaris" ];
  testlinux = mseteq linux [ "aarch64-linux" "armv5tel-linux" "armv6l-linux" "armv7a-linux" "armv7l-linux" "i686-linux" "loongarch64-linux" "m68k-linux" "microblaze-linux" "microblazeel-linux" "mips-linux" "mips64-linux" "mips64el-linux" "mipsel-linux" "powerpc64-linux" "powerpc64le-linux" "riscv32-linux" "riscv64-linux" "s390-linux" "s390x-linux" "x86_64-linux" ];
  testnetbsd = mseteq netbsd [ "aarch64-netbsd" "armv6l-netbsd" "armv7a-netbsd" "armv7l-netbsd" "i686-netbsd" "m68k-netbsd" "mipsel-netbsd" "powerpc-netbsd" "riscv32-netbsd" "riscv64-netbsd" "x86_64-netbsd" ];
  testopenbsd = mseteq openbsd [ "i686-openbsd" "x86_64-openbsd" ];
  testwindows = mseteq windows [ "i686-cygwin" "x86_64-cygwin" "aarch64-windows" "i686-windows" "x86_64-windows" ];
  testunix = mseteq unix (linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos ++ cygwin ++ redox);
})

// {
  test_equals_example_x86_64-linux = {
    expr = lib.systems.equals (lib.systems.elaborate "x86_64-linux") (lib.systems.elaborate "x86_64-linux");
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
    expr = (lib.systems.elaborate { config = "i686-unknown-linux-gnu"; system = "x86_64-linux"; }).system;
    expected = "i686-linux";
  };
  test_elaborate_config_over_parsed = {
    expr = (lib.systems.elaborate { config = "i686-unknown-linux-gnu"; parsed = (lib.systems.elaborate "x86_64-linux").parsed; }).parsed.cpu.arch;
    expected = "i686";
  };
  test_elaborate_system_over_parsed = {
    expr = (lib.systems.elaborate { system = "i686-linux"; parsed = (lib.systems.elaborate "x86_64-linux").parsed; }).parsed.cpu.arch;
    expected = "i686";
  };

  test_elaborate_go_osArch = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
      }).go.osArch;
    expected = "linux/arm64";
  };
  test_elaborate_cgo_supported = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
      }).go.cgoSupported;
    expected = true;
  };
  test_elaborate_cgo_unsupported = {
    expr =
      (lib.systems.elaborate {
        system = "wasm64-wasi";
      }).go.cgoSupported;
    expected = false;
  };
  test_elaborate_go_raceDetectorSupported = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
      }).go.raceDetectorSupported;
    expected = true;
  };
  test_elaborate_go_raceDetectorUnsupported = {
    expr =
      (lib.systems.elaborate {
        system = "armv6l-linux";
      }).go.raceDetectorSupported;
    expected = false;
  };
  test_elaborate_go386_hardfloat = {
    expr =
      (lib.systems.elaborate {
        config = "i686-unknown-linux-gnu";
      }).go.env.GO386;
    expected = "sse2";
  };
  test_elaborate_go386_softfloat = {
    expr =
      (lib.systems.elaborate {
        config = "i686-unknown-linux-gnueabi";
      }).go.env.GO386;
    expected = "softfloat";
  };
  test_elaborate_goarm_from_cpu_version = {
    expr =
      (lib.systems.elaborate {
        system = "armv6l-linux";
      }).go.env.GOARM;
    expected = "6,hardfloat";
  };
  test_elaborate_goarm_from_cpu_version_softfloat = {
    expr =
      (lib.systems.elaborate {
        config = "armv6l-unknown-linux-gnueabi";
      }).go.env.GOARM;
    expected = "6,softfloat";
  };
  test_elaborate_goarm_from_cpu_version_hardfloat = {
    expr =
      (lib.systems.elaborate {
        config = "armv6l-unknown-linux-gnueabihf";
      }).go.env.GOARM;
    expected = "6,hardfloat";
  };
  test_elaborate_goarm64_from_gcc_arch_with_version = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
        gcc.arch = "armv8.3-a";
      }).go.env.GOARM64;
    expected = "v8.3";
  };
  test_elaborate_goarm64_from_gcc_arch_armv8 = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
        gcc.arch = "armv8-a";
      }).go.env.GOARM64;
    expected = "v8.0";
  };
  test_elaborate_goarm64_from_gcc_arch_armv9 = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
        gcc.arch = "armv9-a";
      }).go.env.GOARM64;
    expected = "v9.0";
  };
  test_elaborate_goarm64_from_gcc_arch_with_one_extension = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
        gcc.arch = "armv8-a+crypto";
      }).go.env.GOARM64;
    expected = "v8.0,crypto";
  };
  test_elaborate_goarm64_from_gcc_arch_with_version_and_extensions = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
        gcc.arch = "armv8.3-a+lse+unknown-filtered+crypto";
      }).go.env.GOARM64;
    expected = "v8.3,crypto,lse";
  };
  test_elaborate_goarm64_from_gcc_arch_disabled_extensions = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
        gcc.arch = "armv8.3-a+noext+lse+crypto";
      }).go.env.GOARM64;
    expected = "v8.3";
  };
  test_elaborate_goarm64_from_gcc_arch_invalid_version = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
        gcc.arch = "armv99.99-x";
      }).go.env.GOARM64;
    expected = "v8.0";
  };
  test_elaborate_goarm64 = {
    expr =
      (lib.systems.elaborate {
        system = "aarch64-linux";
      }).go.env.GOARM64;
    expected = "v8.0";
  };
  test_elaborate_goamd64 = {
    expr =
      (lib.systems.elaborate {
        system = "x86_64-linux";
      }).go.env.GOAMD64;
    expected = "v1";
  };
  test_elaborate_goamd64_from_gcc_arch_unknown = {
    expr =
      (lib.systems.elaborate {
        system = "x86_64-linux";
        gcc.arch = "znver5";
      }).go.env.GOAMD64;
    expected = "v1";
  };
  test_elaborate_goamd64_from_gcc_arch_level = {
    expr =
      (lib.systems.elaborate {
        system = "x86_64-linux";
        gcc.arch = "x86-64-v3";
      }).go.env.GOAMD64;
    expected = "v3";
  };
  test_elaborate_gorisv64 = {
    expr =
      (lib.systems.elaborate {
        system = "riscv64-linux";
      }).go.env.GORISCV64;
    expected = "rva20u64";
  };
  test_elaborate_gorisv64_from_gcc_arch = {
    expr =
      (lib.systems.elaborate {
        system = "riscv64-linux";
        gcc.arch = "rva22u64";
      }).go.env.GORISCV64;
    expected = "rva22u64";
  };
  test_elaborate_gorisv64_from_gcc_arch_invalid = {
    expr =
      (lib.systems.elaborate {
        system = "riscv64-linux";
        gcc.arch = "rva22";
      }).go.env.GORISCV64;
    expected = "rva20u64";
  };
  test_elaborate_goppc64 = {
    expr =
      (lib.systems.elaborate {
        config = "powerpc64le-unknown-linux-gnu";
      }).go.env.GOPPC64;
    expected = "power8";
  };
  test_elaborate_goppc64_from_gcc_cpu = {
    expr =
      (lib.systems.elaborate {
        config = "powerpc64le-unknown-linux-gnu";
        gcc.cpu = "power10";
      }).go.env.GOPPC64;
    expected = "power10";
  };
  test_elaborate_gowasm = {
    expr =
      (lib.systems.elaborate {
        system = "wasm64-wasi";
      }).go.env.GOWASM;
    expected = "";
  };
  test_elaborate_gowasm_from_user = {
    expr =
      (lib.systems.elaborate {
        system = "wasm64-wasi";
        go.env.GOWASM = "satconv,signext";
      }).go.env.GOWASM;
    expected = "satconv,signext";
  };
  test_elaborate_goos_wasip1 = {
    expr =
      (lib.systems.elaborate {
        system = "wasm64-wasi";
      }).go.env.GOOS;
    expected = "wasip1";
  };
}

# Generate test cases to assert that a change in any non-function attribute makes a platform unequal
// lib.concatMapAttrs (platformAttrName: origValue: {

  ${"test_equals_unequal_${platformAttrName}"} =
    let modified =
          assert origValue != arbitraryValue;
          lib.systems.elaborate "x86_64-linux" // { ${platformAttrName} = arbitraryValue; };
        arbitraryValue = x: "<<modified>>";
    in {
      expr = lib.systems.equals (lib.systems.elaborate "x86_64-linux") modified;
      expected = {
        # Changes in these attrs are not detectable because they're function.
        # The functions should be derived from the data, so this is not a problem.
        canExecute = null;
        emulator = null;
        emulatorAvailable = null;
        staticEmulatorAvailable = null;
        isCompatible = null;
      }?${platformAttrName};
    };

}) (lib.systems.elaborate "x86_64-linux" /* arbitrary choice, just to get all the elaborated attrNames */)

)
