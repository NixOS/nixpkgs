{ pkgs, lib, ... }:
let
  testCDIScript = pkgs.writeShellScriptBin "test-cdi" ''
    die() {
      echo "$1"
      exit 1
    }

    check_file_referential_integrity() {
      echo "checking $1 referential integrity"
      ( ${pkgs.glibc.bin}/bin/ldd "$1" | ${lib.getExe pkgs.gnugrep} "not found" &> /dev/null ) && return 1
      return 0
    }

    check_directory_referential_integrity() {
      ${lib.getExe pkgs.findutils} "$1" -type f -print0 | while read -d $'\0' file; do
        if [[ $(${lib.getExe pkgs.file} "$file" | ${lib.getExe pkgs.gnugrep} ELF) ]]; then
          check_file_referential_integrity "$file" || exit 1
        else
          echo "skipping $file: not an ELF file"
        fi
      done
    }

    check_directory_referential_integrity "/usr/bin" || exit 1
    check_directory_referential_integrity "${pkgs.addDriverRunpath.driverLink}" || exit 1
    check_directory_referential_integrity "/usr/local/nvidia" || exit 1
  '';
  testContainerImage = pkgs.dockerTools.buildImage {
    name = "cdi-test";
    tag = "latest";
    config = {
      Cmd = [ (lib.getExe testCDIScript) ];
    };
    copyToRoot = with pkgs.dockerTools; [
      usrBinEnv
      binSh
    ];
  };
  emptyCDISpec = ''
    {
      "cdiVersion": "0.5.0",
      "kind": "nvidia.com/gpu",
      "devices": [
        {
          "name": "all",
          "containerEdits": {
            "deviceNodes": [
              {
                "path": "/dev/urandom"
              }
            ],
            "hooks": [],
            "mounts": []
          }
        }
      ],
      "containerEdits": {
        "deviceNodes": [],
        "hooks": [],
        "mounts": []
      }
    }
  '';
  nvidia-container-toolkit = {
    enable = true;
    package = pkgs.stdenv.mkDerivation {
      pname = "nvidia-ctk-dummy";
      version = "1.0.0";
      dontUnpack = true;
      dontBuild = true;

      inherit emptyCDISpec;
      passAsFile = [ "emptyCDISpec" ];

      installPhase = ''
        mkdir -p $out/bin $out/share/nvidia-container-toolkit
        cp "$emptyCDISpecPath" "$out/share/nvidia-container-toolkit/spec.json"
        echo -n "$emptyCDISpec" > "$out/bin/nvidia-ctk";
        cat << EOF > "$out/bin/nvidia-ctk"
        #!${pkgs.runtimeShell}
        cat "$out/share/nvidia-container-toolkit/spec.json"
        EOF
        chmod +x $out/bin/nvidia-ctk
      '';
      meta.mainProgram = "nvidia-ctk";
    };
    suppressNvidiaDriverAssertion = true;
  };
in
{
  name = "nvidia-container-toolkit";
  meta = with lib.maintainers; {
    maintainers = [
      ereslibre
      christoph-heiss
    ];
  };
  defaults =
    { config, ... }:
    {
      environment.systemPackages = with pkgs; [ jq ];
      virtualisation.diskSize = lib.mkDefault 10240;
      virtualisation.containers = {
        containersConf.settings.engine.cdi_spec_dirs = [ "/var/run/cdi" ];
        enable = lib.mkDefault true;
      };
      hardware = {
        inherit nvidia-container-toolkit;
        nvidia = {
          open = true;
          package = config.boot.kernelPackages.nvidiaPackages.stable.open;
        };
        graphics.enable = lib.mkDefault true;
      };
    };
  nodes = {
    no-gpus = {
      virtualisation.containers.enable = false;
    };

    one-gpu =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ podman ];
        hardware.graphics.enable = true;
      };

    one-gpu-invalid-host-paths = {
      hardware.nvidia-container-toolkit.mounts = [
        {
          hostPath = "/non-existant-path";
          containerPath = "/some/path";
        }
      ];
    };
  };
  testScript = ''
    start_all()

    with subtest("Generate an empty CDI spec for a machine with no Nvidia GPUs"):
      no_gpus.wait_for_unit("nvidia-container-toolkit-cdi-generator.service")
      no_gpus.succeed("cat /var/run/cdi/nvidia-container-toolkit.json | jq")

    with subtest("Podman loads the generated CDI spec for a machine with an Nvidia GPU"):
      one_gpu.wait_for_unit("nvidia-container-toolkit-cdi-generator.service")
      one_gpu.succeed("cat /var/run/cdi/nvidia-container-toolkit.json | jq")
      one_gpu.succeed("podman load < ${testContainerImage}")
      one_gpu.succeed("podman run --pull=never --device=nvidia.com/gpu=all -v /run/opengl-driver:/run/opengl-driver:ro cdi-test:latest")

    # Issue: https://github.com/NixOS/nixpkgs/issues/319201
    with subtest("The generated CDI spec skips specified non-existant paths in the host"):
      one_gpu_invalid_host_paths.wait_for_unit("nvidia-container-toolkit-cdi-generator.service")
      one_gpu_invalid_host_paths.fail("grep 'non-existant-path' /var/run/cdi/nvidia-container-toolkit.json")
  '';
}
