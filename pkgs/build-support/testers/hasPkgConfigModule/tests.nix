# cd nixpkgs
# nix-build -A tests.testers.hasPkgConfigModule
{ lib, testers, zlib, runCommand }:

lib.recurseIntoAttrs {

  zlib-has-zlib = testers.hasPkgConfigModule {
    package = zlib;
    moduleName = "zlib";
  };

  zlib-does-not-have-ylib = runCommand "zlib-does-not-have-ylib" {
    failed = testers.testBuildFailure (
      testers.hasPkgConfigModule {
      package = zlib;
      moduleName = "ylib";
      }
    );
  } ''
    echo 'it logs a relevant error message'
    {
      grep -F "pkg-config module ylib was not found" $failed/testBuildFailure.log
    }

    echo 'it logs which pkg-config modules are available, to be helpful'
    {
      # grep -v: the string zlib does also occur in a store path in an earlier message, which isn't particularly helpful
      grep -v "checking pkg-config module" < $failed/testBuildFailure.log \
        | grep -F "zlib"
    }

    # done
    touch $out
  '';

}
