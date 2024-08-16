import ./make-test-python.nix (
  {
    pkgs,
    lib,
    system,
    ...
  }:
  let
    testContainerImage =
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
      in
      pkgs.dockerTools.buildImage {
        name = "cdi-test";
        tag = "latest";
        config = {
          Cmd = [ "${testCDIScript}/bin/test-cdi" ];
        };
        copyToRoot = (
          with pkgs.dockerTools;
          [
            usrBinEnv
            binSh
          ]
        );
      };
    emptyCDISpec = ''
      #! ${pkgs.runtimeShell}
      cat <<CDI_DOCUMENT
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
      CDI_DOCUMENT
    '';
    nvidia-container-toolkit = {
      enable = true;
      package = pkgs.stdenv.mkDerivation {
        name = "nvidia-ctk-dummy";
        version = "1.0.0";
        dontUnpack = true;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/bin
          cat <<EOF > $out/bin/nvidia-ctk
            ${emptyCDISpec}
          EOF
          chmod +x $out/bin/nvidia-ctk
        '';
      };
    };
  in
  {
    name = "nvidia-container-toolkit";
    meta = with lib.maintainers; {
      maintainers = [ ereslibre ];
    };
    nodes = {
      no-nvidia-gpus =
        { config, ... }:
        {
          environment.systemPackages = with pkgs; [ jq ];
          hardware = {
            inherit nvidia-container-toolkit;
            nvidia = {
              open = true;
              package = config.boot.kernelPackages.nvidiaPackages.stable.open;
            };
          };
        };

      nvidia-one-gpu =
        { config, pkgs, ... }:
        {
          virtualisation.diskSize = 10240;
          environment.systemPackages = with pkgs; [
            jq
            podman
          ];
          hardware = {
            inherit nvidia-container-toolkit;
            nvidia = {
              open = true;
              package = config.boot.kernelPackages.nvidiaPackages.stable.open;
            };
            opengl.enable = true;
          };
          virtualisation.containers.enable = true;
        };

      nvidia-one-gpu-invalid-host-paths =
        { config, pkgs, ... }:
        {
          virtualisation.diskSize = 10240;
          environment.systemPackages = with pkgs; [ jq ];
          hardware = {
            nvidia-container-toolkit = nvidia-container-toolkit // {
              mounts = [
                {
                  hostPath = "/non-existant-path";
                  containerPath = "/some/path";
                }
              ];
            };
            nvidia = {
              open = true;
              package = config.boot.kernelPackages.nvidiaPackages.stable.open;
            };
            opengl.enable = true;
          };
          virtualisation.containers.enable = true;
        };
    };
    testScript = ''
      start_all()

      with subtest("Generate an empty CDI spec for a machine with no Nvidia GPUs"):
        no_nvidia_gpus.wait_for_unit("nvidia-container-toolkit-cdi-generator.service")
        no_nvidia_gpus.succeed("cat /var/run/cdi/nvidia-container-toolkit.json | jq")

      with subtest("Podman loads the generated CDI spec for a machine with an Nvidia GPU"):
        nvidia_one_gpu.wait_for_unit("nvidia-container-toolkit-cdi-generator.service")
        nvidia_one_gpu.succeed("cat /var/run/cdi/nvidia-container-toolkit.json | jq")
        nvidia_one_gpu.succeed("podman load < ${testContainerImage}")
        print(nvidia_one_gpu.succeed("podman run --pull=never --device=nvidia.com/gpu=all -v /run/opengl-driver:/run/opengl-driver:ro cdi-test:latest"))

      # Issue: https://github.com/NixOS/nixpkgs/issues/319201
      with subtest("The generated CDI spec skips specified non-existant paths in the host"):
        nvidia_one_gpu_invalid_host_paths.wait_for_unit("nvidia-container-toolkit-cdi-generator.service")
        nvidia_one_gpu_invalid_host_paths.fail("grep 'non-existant-path' /var/run/cdi/nvidia-container-toolkit.json")
    '';
  }
)
