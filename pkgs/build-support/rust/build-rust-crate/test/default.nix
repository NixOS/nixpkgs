{ lib, buildRustCrate, runCommand, writeTextFile, symlinkJoin, callPackage, releaseTools }:
let
  mkCrate = args: let
      p = {
        crateName = "nixtestcrate";
        version = "0.1.0";
        authors = [ "Test <test@example.com>" ];
      } // args;
    in buildRustCrate p;

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

  in rec {

  tests = let
    cases = {
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

    };
    brotliCrates = (callPackage ./brotli-crates.nix {});
  in lib.mapAttrs (key: value: mkTest (value // lib.optionalAttrs (!value?crateName) { crateName = key; })) cases // {
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
