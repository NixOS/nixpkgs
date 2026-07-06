# cd nixpkgs
# nix-build -A tests.testers.hasCmakeConfigModules
{
  lib,
  testers,
  boost,
  mpi,
  eigen,
  runCommand,
}:

lib.recurseIntoAttrs {

  boost-versions-match = testers.hasCmakeConfigModules {
    package = boost;
    moduleNames = [
      "Boost"
      "boost_math"
    ];
    versionCheck = true;
  };

  boost-versions-mismatch = testers.testBuildFailure (
    testers.hasCmakeConfigModules {
      package = boost;
      moduleNames = [
        "Boost"
        "boost_math"
      ];
      version = "1.2.3"; # Deliberately-incorrect version number
      versionCheck = true;
    }
  );

  boost-no-versionCheck = testers.hasCmakeConfigModules {
    package = boost;
    moduleNames = [
      "Boost"
      "boost_math"
    ];
    version = "1.2.3"; # Deliberately-incorrect version number
    versionCheck = false;
  };

  boost-has-boost_mpi = testers.hasCmakeConfigModules {
    package = boost.override { useMpi = true; };
    moduleNames = [
      "boost_mpi"
    ];
    buildInputs = [ mpi ];
  };

  boost_mpi-does-not-have-mpi = testers.testBuildFailure (
    testers.hasCmakeConfigModules {
      package = boost.override { useMpi = true; };
      moduleNames = [
        "boost_mpi"
      ];
    }
  );

  eigen-has-Eigen = testers.hasCmakeConfigModules {
    package = eigen;
    moduleNames = [ "Eigen3" ];
  };

  eigen-does-not-have-eigen = testers.testBuildFailure (
    testers.hasCmakeConfigModules {
      package = eigen;
      moduleNames = [ "eigen3" ];
    }
  );
}
