{ lib, stdenv, buildRustCrate, runCommand, writeTextFile, symlinkJoin }:
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

  mkLib = name: mkFile name "pub fn test() -> i32 { return 23; }";

  mkTest = crateArgs: let
    crate = mkCrate crateArgs;
    binaries = map (v: ''"${v.name}"'') (crateArgs.crateBin or []);
    isLib = crateArgs ? libName || crateArgs ? libPath;
    crateName = crateArgs.crateName or "nixtestcrate";
    libName = crateArgs.libName or crateName;

    libTestBinary = if !isLib then null else mkCrate {
      crateName = "run-test-${crateName}";
      dependencies = [ crate ];
      src = mkFile "src/main.rs" ''
        extern crate ${libName};
        fn main() {
          assert_eq!(${libName}::test(), 23);
        }
      '';
    };

    in runCommand "run-buildRustCrate-${crateName}-test" {
      nativeBuildInputs = [ crate ];
    } ''
      ${lib.concatStringsSep "\n" binaries}
      ${lib.optionalString isLib ''
          test -e ${crate}/lib/*.rlib || exit 1
          ${libTestBinary}/bin/run-test-${crateName}
      ''}
      touch $out
  '';
  in rec {

  tests = let
    cases = {
      libPath =  { libPath = "src/my_lib.rs"; src = mkLib "src/my_lib.rs"; };
      srcLib =  { src = mkLib "src/lib.rs"; };
      customLibName =  { libName = "test_lib"; src = mkLib "src/test_lib.rs"; };
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
    };
  in lib.mapAttrs (key: value: mkTest (value // lib.optionalAttrs (!value?crateName) { crateName = key; })) cases;
  test = runCommand "run-buildRustCrate-tests" {
    nativeBuildInputs = builtins.attrValues tests;
  } "
    touch $out
  ";
}
