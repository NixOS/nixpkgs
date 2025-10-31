{ pkgs, ... }:
let
  # This is the default image used by Nextflow if docker.enabled=true and no
  # process.container is defined.
  bash = pkgs.dockerTools.pullImage {
    imageName = "quay.io/nextflow/bash";
    imageDigest = "sha256:bea0e244b7c5367b2b0de687e7d28f692013aa18970941c7dd184450125163ac";
    sha256 = "sha256-hZOe4qkUHZ4jPGp2Rlc0zG9uq00MYJ7xQV1KS4RLOpg="; # depends on $system!
    finalImageName = "quay.io/nextflow/bash";
  };

  hello = pkgs.stdenv.mkDerivation {
    name = "nextflow-hello";
    src = pkgs.fetchFromGitHub {
      owner = "nextflow-io";
      repo = "hello";
      rev = "afff16a9b45c8e8a4f5a3743780ac13a541762f8";
      hash = "sha256-c8FirHc+J5Y439g0BdHxRtXVrOAzIrGEKA0m1mp9b/U=";
    };
    installPhase = ''
      cp -r $src $out
    '';
  };
  run-nextflow-pipeline = pkgs.writeShellApplication {
    name = "run-nextflow-pipeline";
    text = ''
      export NXF_OFFLINE=true
      for d in true false; do
        for t in true false; do
          rm -f nextflow.config; touch nextflow.config
          echo "docker.enabled = $d" >> nextflow.config
          echo "trace.enabled = $t" >> nextflow.config
          cat nextflow.config
          nextflow run -ansi-log false ${hello}
        done
      done
    '';
  };
in
{
  name = "nextflow";

  nodes.machine =
    { ... }:
    {
      environment.systemPackages = [
        run-nextflow-pipeline
      ];
      programs.nextflow.enable = true;
      virtualisation = {
        docker.enable = true;
      };
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()
      machine.wait_for_unit("docker.service")
      machine.succeed("docker load < ${bash}")
      machine.succeed("run-nextflow-pipeline >&2")
    '';
}
