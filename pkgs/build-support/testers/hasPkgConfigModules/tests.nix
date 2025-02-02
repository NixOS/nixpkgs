# cd nixpkgs
# nix-build -A tests.testers.hasPkgConfigModules
{ lib, testers, miniz, zlib, openssl, runCommand }:

lib.recurseIntoAttrs {

  miniz-versions-match = testers.hasPkgConfigModules {
    package = miniz;
    versionCheck = true;
  };

  miniz-versions-mismatch = testers.testBuildFailure (testers.hasPkgConfigModules {
    package = miniz;
    version = "1.2.3";  # Deliberately-incorrect version number
    versionCheck = true;
  });

  miniz-no-versionCheck = testers.hasPkgConfigModules {
    package = miniz;
    version = "1.2.3";  # Deliberately-incorrect version number
  };

  zlib-has-zlib = testers.hasPkgConfigModules {
    package = zlib;
    moduleNames = [ "zlib" ];
  };

  zlib-has-meta-pkgConfigModules = testers.hasPkgConfigModules {
    package = zlib;
  };

  openssl-has-openssl = testers.hasPkgConfigModules {
    package = openssl;
    moduleNames = [ "openssl" ];
  };

  openssl-has-all-meta-pkgConfigModules = testers.hasPkgConfigModules {
    package = openssl;
  };

  zlib-does-not-have-ylib = runCommand "zlib-does-not-have-ylib" {
    failed = testers.testBuildFailure (
      testers.hasPkgConfigModules {
      package = zlib;
      moduleNames = [ "ylib" ];
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
