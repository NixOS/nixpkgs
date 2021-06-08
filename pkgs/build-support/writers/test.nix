{ glib
, haskellPackages
, lib
, nodePackages
, perlPackages
, python2Packages
, python3Packages
, runCommand
, writers
, writeText
}:
with writers;
let

  bin = {
    bash = writeBashBin "test_writers_bash_bin" ''
     if [[ "test" == "test" ]]; then echo "success"; fi
    '';

    c = writeCBin "test_writers_c" { libraries = [ ]; } ''
      #include <stdio.h>
      int main() {
        printf("success\n");
        return 0;
      }
    '';

    dash = writeDashBin "test_writers_dash_bin" ''
     test '~' = '~' && echo 'success'
    '';

    rust = writeRustBin "test_writers_rust_bin" {} ''
      fn main(){
        println!("success")
      }
    '';

    haskell = writeHaskellBin "test_writers_haskell_bin" { libraries = [ haskellPackages.acme-default ]; } ''
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
    '';

    js = writeJSBin "test_writers_js_bin" { libraries = [ nodePackages.semver ]; } ''
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
    '';

    perl = writePerlBin "test_writers_perl_bin" { libraries = [ perlPackages.boolean ]; } ''
      use boolean;
      print "success\n" if true;
    '';

    python2 = writePython2Bin "test_writers_python2_bin" { libraries = [ python2Packages.enum ]; } ''
      from enum import Enum


      class Test(Enum):
          a = "success"


      print Test.a
    '';

    python3 = writePython3Bin "test_writers_python3_bin" { libraries = [ python3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.load("""
        - test: success
      """)
      print(y[0]['test'])
    '';
  };

  simple = {
    bash = writeBash "test_writers_bash" ''
     if [[ "test" == "test" ]]; then echo "success"; fi
    '';

    c = writeC "test_writers_c" { libraries = [ glib.dev ]; } ''
      #include <gio/gio.h>
      #include <stdio.h>
      int main() {
        GApplication *application = g_application_new ("hello.world", G_APPLICATION_FLAGS_NONE);
        g_application_register (application, NULL, NULL);
        GNotification *notification = g_notification_new ("Hello world!");
        g_notification_set_body (notification, "This is an example notification.");
        GIcon *icon = g_themed_icon_new ("dialog-information");
        g_notification_set_icon (notification, icon);
        g_object_unref (icon);
        g_object_unref (notification);
        g_object_unref (application);
        printf("success\n");
        return 0;
      }
    '';

    dash = writeDash "test_writers_dash" ''
     test '~' = '~' && echo 'success'
    '';

    haskell = writeHaskell "test_writers_haskell" { libraries = [ haskellPackages.acme-default ]; } ''
      import Data.Default

      int :: Int
      int = def

      main :: IO ()
      main = case int of
        18871 -> putStrLn $ id "success"
        _ -> print "fail"
    '';

    js = writeJS "test_writers_js" { libraries = [ nodePackages.semver ]; } ''
      var semver = require('semver');

      if (semver.valid('1.2.3')) {
        console.log('success')
      } else {
        console.log('fail')
      }
    '';

    perl = writePerl "test_writers_perl" { libraries = [ perlPackages.boolean ]; } ''
      use boolean;
      print "success\n" if true;
    '';

    python2 = writePython2 "test_writers_python2" { libraries = [ python2Packages.enum ]; } ''
      from enum import Enum


      class Test(Enum):
          a = "success"


      print Test.a
    '';

    python3 = writePython3 "test_writers_python3" { libraries = [ python3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.load("""
        - test: success
      """)
      print(y[0]['test'])
    '';

    python2NoLibs = writePython2 "test_writers_python2_no_libs" {} ''
      print("success")
    '';

    python3NoLibs = writePython3 "test_writers_python3_no_libs" {} ''
      print("success")
    '';
  };


  path = {
    bash = writeBash "test_writers_bash_path" (writeText "test" ''
      if [[ "test" == "test" ]]; then echo "success"; fi
    '');
    haskell = writeHaskell "test_writers_haskell_path" { libraries = [ haskellPackages.acme-default ]; } (writeText "test" ''
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
  passthru = { inherit writeTest bin simple; };
  meta.platforms = lib.platforms.all;
} ''
  ${lib.concatMapStringsSep "\n" (test: writeTest "success" test.name "${test}/bin/${test.name}") (lib.attrValues bin)}
  ${lib.concatMapStringsSep "\n" (test: writeTest "success" test.name test) (lib.attrValues simple)}
  ${lib.concatMapStringsSep "\n" (test: writeTest "success" test.name test) (lib.attrValues path)}

  echo 'nix-writers successfully tested' >&2
  touch $out
''

