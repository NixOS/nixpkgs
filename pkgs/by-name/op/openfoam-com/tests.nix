{
  testers,
  runCommand,
  openfoam,
}:
{
  version = testers.testVersion {
    package = openfoam;
    command = "simpleFoam -help";
  };

  tutorial = runCommand "${openfoam.name}-tutorials-check" { } ''
    export NIX_OPENFOAM_COM_DEV=${openfoam.dev}
    export NIX_OPENFOAM_COM_TUTORIALS=${openfoam.tutorials}

    set +e
    source ${openfoam}/etc/bashrc
    set -e

    ${openfoam}/bin/foamTestTutorial \
      -parallel \
      -output="$(mktemp -d)" \
      -full \
      incompressible/simpleFoam/pitzDaily \
      | tee run.log

    grep "run: OK" run.log > /dev/null

    touch $out
  '';

  mkExtension =
    let
      fooExt = openfoam.mkExtension {
        name = "foo";
        src = ./test-ext;
      };
    in
    runCommand "${openfoam.name}-mkExtension" { nativeBuildInputs = [ fooExt ]; } ''
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
