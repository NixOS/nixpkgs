{
  pkgs,
  lib,
  ...
}:

let
  olympics-qleverfile = "${pkgs.qlever-control.src}/src/qlever/Qleverfiles/Qleverfile.olympics";

  olympics-dataset = pkgs.fetchurl {
    url = "https://github.com/wallscope/olympics-rdf/raw/54483d539082641d48e1d49873662b3af628ca4d/data/olympics-nt-nodup.zip";
    hash = "sha256-dY28CQKaMDUUw/pw+p9yX0EtJOnbAAplodMFaedL1B8=";
  };
in

{
  name = "Basic QLever test";
  meta.maintainers = lib.teams.ngi.members;

  nodes = {
    machine =
      {
        pkgs,
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          qlever
          qlever-control
          unzip
        ];
      };
  };

  testScript =
    # python
    ''
      machine.succeed("cp ${olympics-dataset} /tmp/olympics.zip")
      machine.succeed("cp ${olympics-qleverfile} /tmp/Qleverfile")
      machine.succeed("unzip -q olympics.zip")

      # use qlever binary instead of docker
      machine.succeed("sed -i 's/SYSTEM = docker/SYSTEM = native/' /tmp/Qleverfile")

      machine.succeed("qlever index")

      machine.succeed("qlever start")
      machine.wait_for_open_port(7019) # default server port

      machine.succeed("qlever query")
    '';
}
