import ./make-test-python.nix (
  { pkgs, ... }:
  let
    bash = pkgs.dockerTools.pullImage {
      imageName = "quay.io/nextflow/bash";
      imageDigest = "sha256:bea0e244b7c5367b2b0de687e7d28f692013aa18970941c7dd184450125163ac";
      sha256 = "161s9f24njjx87qrwq0c9nmnwvyc6iblcxka7hirw78lm7i9x4w5";
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
      runtimeInputs = [ pkgs.nextflow ];
      text = ''
        export NXF_OFFLINE=true
        for b in false true; do
          echo "docker.enabled = $b" > nextflow.config
          cat nextflow.config
          nextflow run -ansi-log false ${hello}
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
          pkgs.nextflow
        ];
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
)
