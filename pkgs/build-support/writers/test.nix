{ glib
, haskellPackages
, lib
, nodePackages
, perlPackages
, pypy2Packages
, python3Packages
, pypy3Packages
, runCommand
, testers
, writers
, writeText
}:
with writers;
let
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
    testers.testEqualContents { expected = expectedFile; actual = file; assertion = "${file.name} matches"; };
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
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
    '');

    js = expectSuccessBin (writeJSBin "test-writers-js-bin" { libraries = [ nodePackages.semver ]; } ''
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
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
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
    '');

    js = expectSuccess (writeJS "test-writers-js" { libraries = [ nodePackages.semver ]; } ''
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
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
      libraries = { fetchNuGet }: [
        (fetchNuGet { pname = "FSharp.SystemTextJson"; version = "0.17.4"; sha256 = "1bplzc9ybdqspii4q28l8gmfvzpkmgq5l1hlsiyg2h46w881lwg2"; })
        (fetchNuGet { pname = "System.Text.Json"; version = "4.6.0"; sha256 = "0ism236hwi0k6axssfq58s1d8lihplwiz058pdvl8al71hagri39"; })
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
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
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
      expected = ''
        hello = "world"
      '';
    };

    yaml = expectDataEqual {
      file = writeYAML "data.yaml" { hello = "world"; };
      expected = "hello: world\n";
    };
  };
}
