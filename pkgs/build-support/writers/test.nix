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
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
    '';

    js = writeJSBin "test-writers-js-bin" { libraries = [ nodePackages.semver ]; } ''
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
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
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
    '';

    js = writeJS "test-writers-js" { libraries = [ nodePackages.semver ]; } ''
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
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
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
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

