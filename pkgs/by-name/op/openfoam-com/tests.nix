{
  testers,
  runCommand,
  openfoam,
}:
let
  inherit (openfoam) pname version;

  mkTutorialsTest =
    { path }:
    runCommand "${pname}-${version}-tutorials-${builtins.replaceStrings [ "/" ] [ "-" ] path}-test"
      {
        env = {
          NIX_OPENFOAM_COM_TUTORIALS = "${openfoam.tutorials}";
        };

        meta.timeout = 300;
      }
      ''
        ${openfoam}/bin/foamTestTutorial \
          -parallel \
          -output="$(mktemp -d)" \
          "${path}" \
          | tee run.log

        grep "run: OK" run.log > /dev/null

        touch $out
      '';
in
{
  version = testers.testVersion {
    package = openfoam;
    command = "simpleFoam -help";
  };

  tutorialsIncompressibleSimpleFoamPitzDaily = mkTutorialsTest {
    path = "incompressible/simpleFoam/pitzDaily";
  };

  # uses scotch
  tutorialsMeshBlockMeshSphere7 = mkTutorialsTest {
    path = "mesh/blockMesh/sphere7";
  };

  # uses ptscotch
  tutorialsIncompressiblePisoFoamLESMotorBikeMotorBike = mkTutorialsTest {
    path = "incompressible/pisoFoam/LES/motorBike/motorBike";
  };

  # uses fftw
  tutorialsIncompressiblePimpleFoamLESDecayIsoTurb = mkTutorialsTest {
    path = "incompressible/pimpleFoam/LES/decayIsoTurb";
  };

  tutorialsMeshFoamyHexMeshSimpleShapes = mkTutorialsTest {
    path = "mesh/foamyHexMesh/simpleShapes";
  };

  mkExtension =
    let
      fooExt = openfoam.mkExtension {
        name = "foo";
        src = ./test-ext;
      };
    in
    runCommand "${pname}-${version}-mkExtension-test" { nativeBuildInputs = [ fooExt ]; } ''
      mkdir system

      cat <<EOT >> system/controlDict
        FoamFile
        {
            version     2.0;
            format      ascii;
            class       dictionary;
            object      controlDict;
        }

        deltaT 1;
        writeFrequency 1;
      EOT

      foo | tee run.log
      grep "Done." run.log > /dev/null

      touch $out
    '';
}
