{ glib
, haskellPackages
, lib
, nodePackages
, perlPackages
, pypy2Packages
, python3Packages
, pypy3Packages
, runCommand
, writers
, writeText
}:
with writers;
let
<<<<<<< HEAD
  expectSuccess = test:
    runCommand "run-${test.name}" {} ''
      if [[ "$(${test})" != success ]]; then
        echo 'test ${test.name} failed'
        exit 1
      fi

      touch $out
    '';

  expectSuccessBin = test:
    runCommand "run-${test.name}" {} ''
      if [[ "$(${lib.getExe test})" != success ]]; then
        echo 'test ${test.name} failed'
        exit 1
      fi

      touch $out
    '';

  expectDataEqual = { file, expected }:
    let
      expectedFile = writeText "${file.name}-expected" expected;
    in
    runCommand "run-${file.name}" {} ''
      if ! diff -u ${file} ${expectedFile}; then
        echo 'test ${file.name} failed'
        exit 1
      fi

      touch $out
    '';
in
lib.recurseIntoAttrs {
  bin = lib.recurseIntoAttrs {
    bash = expectSuccessBin (writeBashBin "test-writers-bash-bin" ''
     if [[ "test" == "test" ]]; then echo "success"; fi
    '');

    dash = expectSuccessBin (writeDashBin "test-writers-dash-bin" ''
     test '~' = '~' && echo 'success'
    '');

    fish = expectSuccessBin (writeFishBin "test-writers-fish-bin" ''
      if test "test" = "test"
        echo "success"
      end
    '');

    rust = expectSuccessBin (writeRustBin "test-writers-rust-bin" {} ''
      fn main(){
        println!("success")
      }
    '');

    haskell = expectSuccessBin (writeHaskellBin "test-writers-haskell-bin" { libraries = [ haskellPackages.acme-default ]; } ''
=======

  bin = {
    bash = writeBashBin "test-writers-bash-bin" ''
     if [[ "test" == "test" ]]; then echo "success"; fi
    '';

    dash = writeDashBin "test-writers-dash-bin" ''
     test '~' = '~' && echo 'success'
    '';

    fish = writeFishBin "test-writers-fish-bin" ''
      if test "test" = "test"
        echo "success"
      end
    '';

    rust = writeRustBin "test-writers-rust-bin" {} ''
      fn main(){
        println!("success")
      }
    '';

    haskell = writeHaskellBin "test-writers-haskell-bin" { libraries = [ haskellPackages.acme-default ]; } ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
<<<<<<< HEAD
    '');

    js = expectSuccessBin (writeJSBin "test-writers-js-bin" { libraries = [ nodePackages.semver ]; } ''
=======
    '';

    js = writeJSBin "test-writers-js-bin" { libraries = [ nodePackages.semver ]; } ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
<<<<<<< HEAD
    '');

    perl = expectSuccessBin (writePerlBin "test-writers-perl-bin" { libraries = [ perlPackages.boolean ]; } ''
      use boolean;
      print "success\n" if true;
    '');

    pypy2 = expectSuccessBin (writePyPy2Bin "test-writers-pypy2-bin" { libraries = [ pypy2Packages.enum ]; } ''
      from enum import Enum

      class Test(Enum):
          a = "success"

      print Test.a
    '');

    python3 = expectSuccessBin (writePython3Bin "test-writers-python3-bin" { libraries = [ python3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.safe_load("""
        - test: success
      """)
      print(y[0]['test'])
    '');

    pypy3 = expectSuccessBin (writePyPy3Bin "test-writers-pypy3-bin" { libraries = [ pypy3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.safe_load("""
        - test: success
      """)
      print(y[0]['test'])
    '');
  };

  simple = lib.recurseIntoAttrs {
    bash = expectSuccess (writeBash "test-writers-bash" ''
     if [[ "test" == "test" ]]; then echo "success"; fi
    '');

    dash = expectSuccess (writeDash "test-writers-dash" ''
     test '~' = '~' && echo 'success'
    '');

    fish = expectSuccess (writeFish "test-writers-fish" ''
      if test "test" = "test"
        echo "success"
      end
    '');

    haskell = expectSuccess (writeHaskell "test-writers-haskell" { libraries = [ haskellPackages.acme-default ]; } ''
=======
    '';

    perl = writePerlBin "test-writers-perl-bin" { libraries = [ perlPackages.boolean ]; } ''
      use boolean;
      print "success\n" if true;
    '';

    pypy2 = writePyPy2Bin "test-writers-pypy2-bin" { libraries = [ pypy2Packages.enum ]; } ''
      from enum import Enum


      class Test(Enum):
          a = "success"


      print Test.a
    '';

    python3 = writePython3Bin "test-writers-python3-bin" { libraries = [ python3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.load("""
        - test: success
      """)
      print(y[0]['test'])
    '';

    pypy3 = writePyPy3Bin "test-writers-pypy3-bin" { libraries = [ pypy3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.load("""
        - test: success
      """)
      print(y[0]['test'])
    '';
  };

  simple = {
    bash = writeBash "test-writers-bash" ''
     if [[ "test" == "test" ]]; then echo "success"; fi
    '';

    dash = writeDash "test-writers-dash" ''
     test '~' = '~' && echo 'success'
    '';

    fish = writeFish "test-writers-fish" ''
      if test "test" = "test"
        echo "success"
      end
    '';

    haskell = writeHaskell "test-writers-haskell" { libraries = [ haskellPackages.acme-default ]; } ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
<<<<<<< HEAD
    '');

    js = expectSuccess (writeJS "test-writers-js" { libraries = [ nodePackages.semver ]; } ''
=======
    '';

    js = writeJS "test-writers-js" { libraries = [ nodePackages.semver ]; } ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
<<<<<<< HEAD
    '');

    perl = expectSuccess (writePerl "test-writers-perl" { libraries = [ perlPackages.boolean ]; } ''
      use boolean;
      print "success\n" if true;
    '');

    pypy2 = expectSuccess (writePyPy2 "test-writers-pypy2" { libraries = [ pypy2Packages.enum ]; } ''
      from enum import Enum

      class Test(Enum):
          a = "success"

      print Test.a
    '');

    python3 = expectSuccess (writePython3 "test-writers-python3" { libraries = [ python3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.safe_load("""
        - test: success
      """)
      print(y[0]['test'])
    '');

    pypy3 = expectSuccess (writePyPy3 "test-writers-pypy3" { libraries = [ pypy3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.safe_load("""
        - test: success
      """)
      print(y[0]['test'])
    '');

    fsharp = expectSuccess (makeFSharpWriter {
=======
    '';

    perl = writePerl "test-writers-perl" { libraries = [ perlPackages.boolean ]; } ''
      use boolean;
      print "success\n" if true;
    '';

    pypy2 = writePyPy2 "test-writers-pypy2" { libraries = [ pypy2Packages.enum ]; } ''
      from enum import Enum


      class Test(Enum):
          a = "success"


      print Test.a
    '';

    python3 = writePython3 "test-writers-python3" { libraries = [ python3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.load("""
        - test: success
      """)
      print(y[0]['test'])
    '';

    pypy3 = writePyPy3 "test-writers-pypy3" { libraries = [ pypy3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.load("""
        - test: success
      """)
      print(y[0]['test'])
    '';

    fsharp = makeFSharpWriter {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      libraries = { fetchNuGet }: [
        (fetchNuGet { pname = "FSharp.SystemTextJson"; version = "0.17.4"; sha256 = "1bplzc9ybdqspii4q28l8gmfvzpkmgq5l1hlsiyg2h46w881lwg2"; })
      ];
    } "test-writers-fsharp" ''
      #r "nuget: FSharp.SystemTextJson, 0.17.4"

      module Json =
          open System.Text.Json
          open System.Text.Json.Serialization
          let options = JsonSerializerOptions()
          options.Converters.Add(JsonFSharpConverter())
          let serialize<'a> (o: 'a) = JsonSerializer.Serialize<'a>(o, options)
          let deserialize<'a> (str: string) = JsonSerializer.Deserialize<'a>(str, options)

      type Letter = A | B
      let a = {| Hello = Some "World"; Letter = A |}
      if a |> Json.serialize |> Json.deserialize |> (=) a
      then "success"
      else "failed"
      |> printfn "%s"
<<<<<<< HEAD
    '');

    pypy2NoLibs = expectSuccess (writePyPy2 "test-writers-pypy2-no-libs" {} ''
      print("success")
    '');

    python3NoLibs = expectSuccess (writePython3 "test-writers-python3-no-libs" {} ''
      print("success")
    '');

    pypy3NoLibs = expectSuccess (writePyPy3 "test-writers-pypy3-no-libs" {} ''
      print("success")
    '');

    fsharpNoNugetDeps = expectSuccess (writeFSharp "test-writers-fsharp-no-nuget-deps" ''
      printfn "success"
    '');
  };

  path = lib.recurseIntoAttrs {
    bash = expectSuccess (writeBash "test-writers-bash-path" (writeText "test" ''
      if [[ "test" == "test" ]]; then echo "success"; fi
    ''));

    haskell = expectSuccess (writeHaskell "test-writers-haskell-path" { libraries = [ haskellPackages.acme-default ]; } (writeText "test" ''
=======
    '';

    pypy2NoLibs = writePyPy2 "test-writers-pypy2-no-libs" {} ''
      print("success")
    '';

    python3NoLibs = writePython3 "test-writers-python3-no-libs" {} ''
      print("success")
    '';

    pypy3NoLibs = writePyPy3 "test-writers-pypy3-no-libs" {} ''
      print("success")
    '';

    fsharpNoNugetDeps = writeFSharp "test-writers-fsharp-no-nuget-deps" ''
      printfn "success"
    '';
  };


  path = {
    bash = writeBash "test-writers-bash-path" (writeText "test" ''
      if [[ "test" == "test" ]]; then echo "success"; fi
    '');
    haskell = writeHaskell "test-writers-haskell-path" { libraries = [ haskellPackages.acme-default ]; } (writeText "test" ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
<<<<<<< HEAD
    ''));
  };

  data = {
    json = expectDataEqual {
      file = writeJSON "data.json" { hello = "world"; };
      expected = ''
        {
          "hello": "world"
        }
      '';
    };

    toml = expectDataEqual {
      file = writeTOML "data.toml" { hello = "world"; };
      expected = "hello = 'world'\n";
    };

    yaml = expectDataEqual {
      file = writeYAML "data.yaml" { hello = "world"; };
      expected = "hello: world\n";
    };
  };
}
=======
    '');
  };

  writeTest = expectedValue: name: test:
    writeDash "run-${name}" ''
      if test "$(${test})" != "${expectedValue}"; then
        echo 'test ${test} failed'
        exit 1
      fi
    '';

in runCommand "test-writers" {
  passthru = { inherit writeTest bin simple path; };
  meta.platforms = lib.platforms.all;
} ''
  ${lib.concatMapStringsSep "\n" (test: writeTest "success" test.name "${test}/bin/${test.name}") (lib.attrValues bin)}
  ${lib.concatMapStringsSep "\n" (test: writeTest "success" test.name test) (lib.attrValues simple)}
  ${lib.concatMapStringsSep "\n" (test: writeTest "success" test.name test) (lib.attrValues path)}

  echo 'nix-writers successfully tested' >&2
  touch $out
''

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
