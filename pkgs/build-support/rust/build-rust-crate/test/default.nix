{ lib
, buildRustCrate
, callPackage
, releaseTools
, runCommand
, runCommandCC
, stdenv
, symlinkJoin
, writeTextFile
}:

let
  mkCrate = args: let
    p = {
      crateName = "nixtestcrate";
      version = "0.1.0";
      authors = [ "Test <test@example.com>" ];
    } // args;
  in buildRustCrate p;

  mkCargoToml =
    { name, crateVersion ? "0.1.0", path ? "Cargo.toml" }:
      mkFile path ''
        [package]
        name = ${builtins.toJSON name}
        version = ${builtins.toJSON crateVersion}
      '';

  mkFile = destination: text: writeTextFile {
    name = "src";
    destination = "/${destination}";
    inherit text;
  };

  mkBin = name: mkFile name ''
    use std::env;
    fn main() {
      let name: String = env::args().nth(0).unwrap();
      println!("executed {}", name);
    }
  '';

  mkBinExtern = name: extern: mkFile name ''
    extern crate ${extern};
    fn main() {
      assert_eq!(${extern}::test(), 23);
    }
  '';

  mkTestFile = name: functionName: mkFile name ''
    #[cfg(test)]
    #[test]
    fn ${functionName}() {
      assert!(true);
    }
  '';
  mkTestFileWithMain = name: functionName: mkFile name ''
    #[cfg(test)]
    #[test]
    fn ${functionName}() {
      assert!(true);
    }

    fn main() {}
  '';


  mkLib = name: mkFile name "pub fn test() -> i32 { return 23; }";

  mkTest = crateArgs: let
    crate = mkCrate (builtins.removeAttrs crateArgs ["expectedTestOutput"]);
    hasTests = crateArgs.buildTests or false;
    expectedTestOutputs = crateArgs.expectedTestOutputs or null;
    binaries = map (v: ''"${v.name}"'') (crateArgs.crateBin or []);
    isLib = crateArgs ? libName || crateArgs ? libPath;
    crateName = crateArgs.crateName or "nixtestcrate";
    libName = crateArgs.libName or crateName;

    libTestBinary = if !isLib then null else mkCrate {
      crateName = "run-test-${crateName}";
      dependencies = [ crate ];
      src = mkBinExtern "src/main.rs" libName;
    };

    in
      assert expectedTestOutputs != null -> hasTests;
      assert hasTests -> expectedTestOutputs != null;

      runCommand "run-buildRustCrate-${crateName}-test" {
        nativeBuildInputs = [ crate ];
      } (if !hasTests then ''
          ${lib.concatStringsSep "\n" binaries}
          ${lib.optionalString isLib ''
              test -e ${crate}/lib/*.rlib || exit 1
              ${libTestBinary}/bin/run-test-${crateName}
          ''}
          touch $out
        '' else ''
          for file in ${crate}/tests/*; do
            $file 2>&1 >> $out
          done
          set -e
          ${lib.concatMapStringsSep "\n" (o: "grep '${o}' $out || {  echo 'output \"${o}\" not found in:'; cat $out; exit 23; }") expectedTestOutputs}
        ''
      );

    /* Returns a derivation that asserts that the crate specified by `crateArgs`
       has the specified files as output.

       `name` is used as part of the derivation name that performs the checking.

       `crateArgs` is passed to `mkCrate` to build the crate with `buildRustCrate`.

       `expectedFiles` contains a list of expected file paths in the output. E.g.
       `[ "./bin/my_binary" ]`.

       `output` specifies the name of the output to use. By default, the default
       output is used but e.g. `output = "lib";` will cause the lib output
       to be checked instead. You do not need to specify any directories.
     */
    assertOutputs = { name, crateArgs, expectedFiles, output? null }:
      assert (builtins.isString name);
      assert (builtins.isAttrs crateArgs);
      assert (builtins.isList expectedFiles);

      let
        crate = mkCrate (builtins.removeAttrs crateArgs ["expectedTestOutput"]);
        crateOutput = if output == null then crate else crate."${output}";
        expectedFilesFile = writeTextFile {
          name = "expected-files-${name}";
          text =
            let sorted = builtins.sort (a: b: a<b) expectedFiles;
                concatenated = builtins.concatStringsSep "\n" sorted;
            in "${concatenated}\n";
        };
      in
      runCommand "assert-outputs-${name}" {
      } ''
      local actualFiles=$(mktemp)

      cd "${crateOutput}"
      find . -type f | sort >$actualFiles
      diff -q ${expectedFilesFile} $actualFiles >/dev/null || {
        echo -e "\033[0;1;31mERROR: Difference in expected output files in ${crateOutput} \033[0m" >&2
        echo === Got:
        sed -e 's/^/  /' $actualFiles
        echo === Expected:
        sed -e 's/^/  /' ${expectedFilesFile}
        echo === Diff:
        diff -u ${expectedFilesFile} $actualFiles |\
          tail -n +3 |\
          sed -e 's/^/  /'
        exit 1
      }
      touch $out
      ''
      ;

  in rec {

  tests = let
    cases = rec {
      libPath =  { libPath = "src/my_lib.rs"; src = mkLib "src/my_lib.rs"; };
      srcLib =  { src = mkLib "src/lib.rs"; };

      # This used to be supported by cargo but as of 1.40.0 I can't make it work like that with just cargo anymore.
      # This might be a regression or deprecated thing they finally removed…
      # customLibName =  { libName = "test_lib"; src = mkLib "src/test_lib.rs"; };
      # rustLibTestsCustomLibName = {
      #   libName = "test_lib";
      #   src = mkTestFile "src/test_lib.rs" "foo";
      #   buildTests = true;
      #   expectedTestOutputs = [ "test foo ... ok" ];
      # };

      customLibNameAndLibPath =  { libName = "test_lib"; libPath = "src/best-lib.rs"; src = mkLib "src/best-lib.rs"; };
      crateBinWithPath =  { crateBin = [{ name = "test_binary1"; path = "src/foobar.rs"; }]; src = mkBin "src/foobar.rs"; };
      crateBinNoPath1 =  { crateBin = [{ name = "my-binary2"; }]; src = mkBin "src/my_binary2.rs"; };
      crateBinNoPath2 =  {
        crateBin = [{ name = "my-binary3"; } { name = "my-binary4"; }];
        src = symlinkJoin {
          name = "buildRustCrateMultipleBinariesCase";
          paths = [ (mkBin "src/bin/my_binary3.rs") (mkBin "src/bin/my_binary4.rs") ];
        };
      };
      crateBinNoPath3 =  { crateBin = [{ name = "my-binary5"; }]; src = mkBin "src/bin/main.rs"; };
      crateBinNoPath4 =  { crateBin = [{ name = "my-binary6"; }]; src = mkBin "src/main.rs";};
      crateBinRename1 = {
        crateBin = [{ name = "my-binary-rename1"; }];
        src = mkBinExtern "src/main.rs" "foo_renamed";
        dependencies = [ (mkCrate { crateName = "foo"; src = mkLib "src/lib.rs"; }) ];
        crateRenames = { "foo" = "foo_renamed"; };
      };
      crateBinRename2 = {
        crateBin = [{ name = "my-binary-rename2"; }];
        src = mkBinExtern "src/main.rs" "foo_renamed";
        dependencies = [ (mkCrate { crateName = "foo"; libName = "foolib"; src = mkLib "src/lib.rs"; }) ];
        crateRenames = { "foo" = "foo_renamed"; };
      };
      rustLibTestsDefault = {
        src = mkTestFile "src/lib.rs" "baz";
        buildTests = true;
        expectedTestOutputs = [ "test baz ... ok" ];
      };
      rustLibTestsCustomLibPath = {
        libPath = "src/test_path.rs";
        src = mkTestFile "src/test_path.rs" "bar";
        buildTests = true;
        expectedTestOutputs = [ "test bar ... ok" ];
      };
      rustLibTestsCustomLibPathWithTests = {
        libPath = "src/test_path.rs";
        src = symlinkJoin {
          name = "rust-lib-tests-custom-lib-path-with-tests-dir";
          paths = [
            (mkTestFile "src/test_path.rs" "bar")
            (mkTestFile "tests/something.rs" "something")
          ];
        };
        buildTests = true;
        expectedTestOutputs = [
          "test bar ... ok"
          "test something ... ok"
        ];
      };
      rustBinTestsCombined = {
        src = symlinkJoin {
          name = "rust-bin-tests-combined";
          paths = [
            (mkTestFileWithMain "src/main.rs" "src_main")
            (mkTestFile "tests/foo.rs" "tests_foo")
            (mkTestFile "tests/bar.rs" "tests_bar")
          ];
        };
        buildTests = true;
        expectedTestOutputs = [
          "test src_main ... ok"
          "test tests_foo ... ok"
          "test tests_bar ... ok"
        ];
      };
      rustBinTestsSubdirCombined = {
        src = symlinkJoin {
          name = "rust-bin-tests-subdir-combined";
          paths = [
            (mkTestFileWithMain "src/main.rs" "src_main")
            (mkTestFile "tests/foo/main.rs" "tests_foo")
            (mkTestFile "tests/bar/main.rs" "tests_bar")
          ];
        };
        buildTests = true;
        expectedTestOutputs = [
          "test src_main ... ok"
          "test tests_foo ... ok"
          "test tests_bar ... ok"
        ];
      };
      linkAgainstRlibCrate = {
        crateName = "foo";
        src = mkFile  "src/main.rs" ''
          extern crate somerlib;
          fn main() {}
        '';
        dependencies = [
          (mkCrate {
            crateName = "somerlib";
            type = [ "rlib" ];
            src = mkLib "src/lib.rs";
          })
        ];
      };
      buildScriptDeps = let
        depCrate = boolVal: mkCrate {
          crateName = "bar";
          src = mkFile "src/lib.rs" ''
            pub const baz: bool = ${boolVal};
          '';
        };
      in {
        crateName = "foo";
        src = symlinkJoin {
          name = "build-script-and-main";
          paths = [
            (mkFile  "src/main.rs" ''
              extern crate bar;
              #[cfg(test)]
              #[test]
              fn baz_false() { assert!(!bar::baz); }
              fn main() { }
            '')
            (mkFile  "build.rs" ''
              extern crate bar;
              fn main() { assert!(bar::baz); }
            '')
          ];
        };
        buildDependencies = [ (depCrate "true") ];
        dependencies = [ (depCrate "false") ];
        buildTests = true;
        expectedTestOutputs = [ "test baz_false ... ok" ];
      };
      # Regression test for https://github.com/NixOS/nixpkgs/issues/74071
      # Whenevever a build.rs file is generating files those should not be overlayed onto the actual source dir
      buildRsOutDirOverlay = {
        src = symlinkJoin {
          name = "buildrs-out-dir-overlay";
          paths = [
            (mkLib "src/lib.rs")
            (mkFile "build.rs" ''
              use std::env;
              use std::ffi::OsString;
              use std::fs;
              use std::path::Path;
              fn main() {
                let out_dir = env::var_os("OUT_DIR").expect("OUT_DIR not set");
                let out_file = Path::new(&out_dir).join("lib.rs");
                fs::write(out_file, "invalid rust code!").expect("failed to write lib.rs");
              }
            '')
          ];
        };
      };
      # Regression test for https://github.com/NixOS/nixpkgs/pull/83379
      # link flag order should be preserved
      linkOrder = {
        src = symlinkJoin {
          name = "buildrs-out-dir-overlay";
          paths = [
            (mkFile "build.rs" ''
              fn main() {
                // in the other order, linkage will fail
                println!("cargo:rustc-link-lib=b");
                println!("cargo:rustc-link-lib=a");
              }
            '')
            (mkFile "src/main.rs" ''
              extern "C" {
                fn hello_world();
              }
              fn main() {
                unsafe {
                  hello_world();
                }
              }
            '')
          ];
        };
        buildInputs = let
          compile = name: text: let
            src = writeTextFile {
              name = "${name}-src.c";
              inherit text;
            };
          in runCommandCC name {} ''
            mkdir -p $out/lib
            # Note: On darwin (which defaults to clang) we have to add
            # `-undefined dynamic_lookup` as otherwise the compilation fails.
            cc -shared \
              ${lib.optionalString stdenv.isDarwin "-undefined dynamic_lookup"} \
              -o $out/lib/${name}${stdenv.hostPlatform.extensions.sharedLibrary} ${src}
          '';
          b = compile "libb" ''
            #include <stdio.h>

            void hello();

            void hello_world() {
              hello();
              printf(" world!\n");
            }
          '';
          a = compile "liba" ''
            #include <stdio.h>

            void hello() {
              printf("hello");
            }
          '';
        in [ a b ];
      };
      rustCargoTomlInSubDir = {
        # The "workspace_member" can be set to the sub directory with the crate to build.
        # By default ".", meaning the top level directory is assumed.
        # Using null will trigger a search.
        workspace_member = null;
        src = symlinkJoin rec {
          name = "find-cargo-toml";
          paths = [
            (mkCargoToml { name = "ignoreMe"; })
            (mkTestFileWithMain "src/main.rs" "ignore_main")

            (mkCargoToml { name = "rustCargoTomlInSubDir"; path = "subdir/Cargo.toml"; })
            (mkTestFileWithMain "subdir/src/main.rs" "src_main")
            (mkTestFile "subdir/tests/foo/main.rs" "tests_foo")
            (mkTestFile "subdir/tests/bar/main.rs" "tests_bar")
          ];
        };
        buildTests = true;
        expectedTestOutputs = [
          "test src_main ... ok"
          "test tests_foo ... ok"
          "test tests_bar ... ok"
        ];
      };

      rustCargoTomlInTopDir =
        let
          withoutCargoTomlSearch = builtins.removeAttrs rustCargoTomlInSubDir [ "workspace_member" ];
        in
          withoutCargoTomlSearch // {
            expectedTestOutputs = [
              "test ignore_main ... ok"
            ];
          };
    };
    brotliCrates = (callPackage ./brotli-crates.nix {});
    tests = lib.mapAttrs (key: value: mkTest (value // lib.optionalAttrs (!value?crateName) { crateName = key; })) cases;
  in tests // rec {

    crateBinWithPathOutputs = assertOutputs {
      name="crateBinWithPath";
      crateArgs = {
        crateBin = [{ name = "test_binary1"; path = "src/foobar.rs"; }];
        src = mkBin "src/foobar.rs";
      };
      expectedFiles = [
        "./bin/test_binary1"
      ];
    };

    crateBinWithPathOutputsDebug = assertOutputs {
      name="crateBinWithPath";
      crateArgs = {
        release = false;
        crateBin = [{ name = "test_binary1"; path = "src/foobar.rs"; }];
        src = mkBin "src/foobar.rs";
      };
      expectedFiles = [
        "./bin/test_binary1"
      ] ++ lib.optionals stdenv.isDarwin [
        # On Darwin, the debug symbols are in a seperate directory.
        "./bin/test_binary1.dSYM/Contents/Info.plist"
        "./bin/test_binary1.dSYM/Contents/Resources/DWARF/test_binary1"
      ];
    };

    crateBinNoPath1Outputs = assertOutputs {
      name="crateBinNoPath1";
      crateArgs = {
        crateBin = [{ name = "my-binary2"; }];
        src = mkBin "src/my_binary2.rs";
      };
      expectedFiles = [
        "./bin/my-binary2"
      ];
    };

    crateLibOutputs = assertOutputs {
      name="crateLib";
      output="lib";
      crateArgs = {
        libName = "test_lib";
        type = [ "rlib" ];
        libPath = "src/lib.rs";
        src = mkLib "src/lib.rs";
      };
      expectedFiles = [
        "./nix-support/propagated-build-inputs"
        "./lib/libtest_lib-042a1fdbef.rlib"
        "./lib/link"
      ];
    };

    crateLibOutputsDebug = assertOutputs {
      name="crateLib";
      output="lib";
      crateArgs = {
        release = false;
        libName = "test_lib";
        type = [ "rlib" ];
        libPath = "src/lib.rs";
        src = mkLib "src/lib.rs";
      };
      expectedFiles = [
        "./nix-support/propagated-build-inputs"
        "./lib/libtest_lib-042a1fdbef.rlib"
        "./lib/link"
      ];
    };

    brotliTest = let
      pkg = brotliCrates.brotli_2_5_0 {};
    in runCommand "run-brotli-test-cmd" {
      nativeBuildInputs = [ pkg ];
    } ''
      ${pkg}/bin/brotli -c ${pkg}/bin/brotli > /dev/null && touch $out
    '';
    allocNoStdLibTest = let
      pkg = brotliCrates.alloc_no_stdlib_1_3_0 {};
    in runCommand "run-alloc-no-stdlib-test-cmd" {
      nativeBuildInputs = [ pkg ];
    } ''
      test -e ${pkg}/bin/example && touch $out
    '';
    brotliDecompressorTest = let
      pkg = brotliCrates.brotli_decompressor_1_3_1 {};
    in runCommand "run-brotli-decompressor-test-cmd" {
      nativeBuildInputs = [ pkg ];
    } ''
      test -e ${pkg}/bin/brotli-decompressor && touch $out
    '';
  };
  test = releaseTools.aggregate {
    name = "buildRustCrate-tests";
    meta = {
      description = "Test cases for buildRustCrate";
      maintainers = [ lib.maintainers.andir ];
    };
    constituents = builtins.attrValues tests;
  };
}
