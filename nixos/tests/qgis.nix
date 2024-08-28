import ./make-test-python.nix ({ pkgs, lib, qgisPackage, ... }:
  let
    testScript = pkgs.writeTextFile {
      name = "qgis-test.py";
      text = (builtins.readFile ../../pkgs/applications/gis/qgis/test.py);
    };
  in
  {
    name = "qgis";
    meta = {
      maintainers = with lib; [ teams.geospatial.members ];
    };

    nodes = {
      machine = { pkgs, ... }: {
        virtualisation.diskSize = 2 * 1024;

        imports = [ ./common/x11.nix ];
        environment.systemPackages = [ qgisPackage ];

      };
    };

    testScript = ''
      start_all()

      machine.succeed("${qgisPackage}/bin/qgis --version | grep 'QGIS ${qgisPackage.version}'")
      machine.succeed("${qgisPackage}/bin/qgis --code ${testScript}")
    '';
  })
