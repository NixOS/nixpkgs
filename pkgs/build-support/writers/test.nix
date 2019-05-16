{ stdenv, lib, runCommand, haskellPackages, nodePackages, perlPackages, python2Packages, python3Packages, writers, writeText }:
with writers;
let

  bin = {
    bash = writeBashBin "test_writers" ''
     if [[ "test" == "test" ]]; then echo "success"; fi
    '';

    c = writeCBin "test_writers" { libraries = [ ]; } ''
      #include <stdio.h>
      int main() {
        printf("success\n");
        return 0;
      }
    '';

    dash = writeDashBin "test_writers" ''
     test '~' = '~' && echo 'success'
    '';

    haskell = writeHaskellBin "test_writers" { libraries = [ haskellPackages.acme-default ]; } ''
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
    '';

    js = writeJSBin "test_writers" { libraries = [ nodePackages.semver ]; } ''
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
    '';

    perl = writePerlBin "test_writers" { libraries = [ perlPackages.boolean ]; } ''
      use boolean;
      print "success\n" if true;
    '';

    python2 = writePython2Bin "test_writers" { libraries = [ python2Packages.enum ]; } ''
      from enum import Enum

      class Test(Enum):
          a = "success"

      print Test.a
    '';

    python3 = writePython3Bin "test_writers" { libraries = [ python3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.load("""
        - test: success
      """)
      print(y[0]['test'])
    '';
  };

  simple = {
    bash = writeBash "test_bash" ''
     if [[ "test" == "test" ]]; then echo "success"; fi
    '';

    c = writeC "test_c" { libraries = [ ]; } ''
      #include <stdio.h>
      int main() {
        printf("success\n");
        return 0;
      }
    '';

    dash = writeDash "test_dash" ''
     test '~' = '~' && echo 'success'
    '';

    haskell = writeHaskell "test_haskell" { libraries = [ haskellPackages.acme-default ]; } ''
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
    '';

    js = writeJS "test_js" { libraries = [ nodePackages.semver ]; } ''
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
    '';

    perl = writePerl "test_perl" { libraries = [ perlPackages.boolean ]; } ''
      use boolean;
      print "success\n" if true;
    '';

    python2 = writePython2 "test_python2" { libraries = [ python2Packages.enum ]; } ''
      from enum import Enum

      class Test(Enum):
          a = "success"

      print Test.a
    '';

    python3 = writePython3 "test_python3" { libraries = [ python3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.load("""
        - test: success
      """)
      print(y[0]['test'])
    '';
  };


  path = {
    bash = writeBash "test_bash" (writeText "test" ''
      if [[ "test" == "test" ]]; then echo "success"; fi
    '');
    haskell = writeHaskell "test_haskell" { libraries = [ haskellPackages.acme-default ]; } (writeText "test" ''
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
    '');
  };

  writeTest = expectedValue: test:
    writeDash "test-writers" ''
      if test "$(${test})" != "${expectedValue}"; then
        echo 'test ${test} failed'
        exit 1
      fi
    '';

in runCommand "test-writers" {
  passthru = { inherit writeTest bin simple; };
  meta.platforms = stdenv.lib.platforms.all;
} ''
  ${lib.concatMapStringsSep "\n" (test: writeTest "success" "${test}/bin/test_writers") (lib.attrValues bin)}
  ${lib.concatMapStringsSep "\n" (test: writeTest "success" "${test}") (lib.attrValues simple)}
  ${lib.concatMapStringsSep "\n" (test: writeTest "success" "${test}") (lib.attrValues path)}

  echo 'nix-writers successfully tested' >&2
  touch $out
''

