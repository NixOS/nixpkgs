{
  lib,
  pkgs,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };
in
{
  options.tests.incus = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "name appended to test";
    };

    package = lib.mkPackageOption pkgs "incus" { };

    preseed = lib.mkOption {
      description = "configuration provided to incus preseed. https://linuxcontainers.org/incus/docs/main/howto/initialize/#non-interactive-configuration";
      type = lib.types.submodule {
        freeformType = jsonFormat.type;
      };
    };

    instances = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                default = name;
              };

              type = lib.mkOption {
                type = lib.types.enum [
                  "container"
                  "virtual-machine"
                ];

              };

              imageAlias = lib.mkOption {
                type = lib.types.str;
                description = "name of image when imported";
                default = "nixos/${name}/${config.type}";
              };

              nixosConfig = lib.mkOption {
                type = lib.types.attrsOf lib.types.anything;
                default = { };
              };

              incusConfig = lib.mkOption {
                type = lib.types.submodule {
                  freeformType = jsonFormat.type;
                };
                description = "incus configuration provided at launch";
                default = { };
              };

              testScript = lib.mkOption {
                type = lib.types.str;
                description = "final script provided to test runner";
                readOnly = true;
              };
            };
            config =
              let
                releases = import ../../release.nix {
                  configuration = config.nixosConfig;
                };

                images = {
                  container = {
                    metadata =
                      releases.incusContainerMeta.${pkgs.stdenv.hostPlatform.system}
                      + "/tarball/nixos-image-lxc-*-${pkgs.stdenv.hostPlatform.system}.tar.xz";

                    root =
                      releases.incusContainerImage.${pkgs.stdenv.hostPlatform.system}
                      + "/nixos-lxc-image-${pkgs.stdenv.hostPlatform.system}.squashfs";
                  };

                  virtual-machine = {
                    metadata = releases.incusVirtualMachineImageMeta.${pkgs.stdenv.hostPlatform.system} + "/*/*.tar.xz";
                    root = releases.incusVirtualMachineImage.${pkgs.stdenv.hostPlatform.system} + "/nixos.qcow2";
                  };
                };

                root = images.${config.type}.root;
                metadata = images.${config.type}.metadata;

                image_id = "${config.type}/${config.name}";
              in
              {
                incusConfig = lib.optionalAttrs (config.type == "virtual-machine") {
                  config."security.secureboot" = false;
                };

                nixosConfig = {
                  # Building documentation makes the test unnecessarily take a longer time:
                  documentation.enable = lib.mkForce false;
                  documentation.nixos.enable = lib.mkForce false;
                  # including a channel forces images to be rebuilt on any changes
                  system.installer.channel.enable = lib.mkForce false;

                  environment.etc."nix/registry.json".text = lib.mkForce "{}";

                  # Arbitrary sysctl setting changed from nixos default
                  # used for verifying `distrobuilder.generator` properly allows
                  # for containers to modify sysctl
                  boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
                };

                testScript = # python
                ''
                  with subtest("[${image_id}] image can be imported"):
                      server.succeed("incus image import ${metadata} ${root} --alias ${config.imageAlias}")

                  with subtest("[${image_id}] can be launched and managed"):
                      instance_name = server.succeed("incus launch ${config.imageAlias}${
                        lib.optionalString (config.type == "virtual-machine") " --vm"
                      } --quiet < ${jsonFormat.generate "${config.name}.json" config.incusConfig}").split(":")[1].strip()
                      server.wait_for_instance(instance_name)

                  with subtest("[${image_id}] can successfully restart"):
                      server.succeed(f"incus restart {instance_name}")
                      server.wait_for_instance(instance_name)

                  with subtest("[${image_id}] remains running when softDaemonRestart is enabled and service is stopped"):
                      pid = server.succeed(f"incus info {instance_name} | grep 'PID'").split(":")[1].strip()
                      server.succeed(f"ps {pid}")
                      server.succeed("systemctl stop incus")
                      server.succeed(f"ps {pid}")
                      server.succeed("systemctl start incus")

                  with subtest("[${image_id}] CPU limits can be managed"):
                      server.set_instance_config(instance_name, "limits.cpu 1", restart=True)
                      server.wait_instance_exec_success(instance_name, "nproc | grep '^1$'", timeout=90)

                  with subtest("[${image_id}] CPU limits can be hotplug changed"):
                      server.set_instance_config(instance_name, "limits.cpu 2")
                      server.wait_instance_exec_success(instance_name, "nproc | grep '^2$'", timeout=90)

                  with subtest("[${image_id}] exec has a valid path"):
                      server.succeed(f"incus exec {instance_name} -- bash -c 'true'")

                  with subtest("[${image_id}] software tpm can be configured"):
                      # this can be hot added to containers, but stopping for vm
                      server.succeed(f"incus stop {instance_name}")
                      server.succeed(f"incus config device add {instance_name} vtpm tpm path=/dev/tpm0 pathrm=/dev/tpmrm0")
                      server.succeed(f"incus start {instance_name}")
                      server.wait_for_instance(instance_name)

                      server.succeed(f"incus exec {instance_name} -- test -e /dev/tpm0")
                      server.succeed(f"incus exec {instance_name} -- test -e /dev/tpmrm0")
                ''
                #
                # container specific
                #
                +
                  lib.optionalString (config.type == "container")
                    # python
                    ''
                      # TODO troubleshoot VM hot memory resizing which was introduced in 6.12
                      with subtest("[${image_id}] memory limits can be hotplug changed"):
                          server.set_instance_config(instance_name, "limits.memory 512MB")
                          # can't use lsmem since it sees the host's memory size
                          server.wait_instance_exec_success(instance_name, "grep 'MemTotal:[[:space:]]*500000 kB' /proc/meminfo", timeout=1)

                      # verify the patched container systemd generator from `pkgs.distrobuilder.generator`
                      with subtest("[${image_id}] lxc-generator compatibility"):
                          with subtest("[${image_id}] lxc-container generator configures plain container"):
                              # default container is plain
                              server.succeed(f"incus exec {instance_name} test -- -e /run/systemd/system/service.d/zzz-lxc-service.conf")

                              server.check_instance_sysctl(instance_name)

                          with subtest("[${image_id}] lxc-container generator configures nested container"):
                              server.set_instance_config(instance_name, "security.nesting=true", restart=True)

                              server.fail(f"incus exec {instance_name} test -- -e /run/systemd/system/service.d/zzz-lxc-service.conf")
                              target = server.succeed(f"incus exec {instance_name} readlink -- -f /run/systemd/system/systemd-binfmt.service").strip()
                              assert target == "/dev/null", "lxc generator did not correctly mask /run/systemd/system/systemd-binfmt.service"

                              server.check_instance_sysctl(instance_name)

                      with subtest("[${image_id}] lxcfs"):
                          with subtest("[${image_id}] mounts lxcfs overlays"):
                              server.succeed(f"incus exec {instance_name} mount | grep 'lxcfs on /proc/cpuinfo type fuse.lxcfs'")
                              server.succeed(f"incus exec {instance_name} mount | grep 'lxcfs on /proc/meminfo type fuse.lxcfs'")

                          with subtest("[${image_id}] supports per-instance lxcfs"):
                              server.succeed(f"incus stop {instance_name}")
                              server.fail(f"pgrep -a lxcfs | grep 'incus/devices/{instance_name}/lxcfs'")

                              server.succeed("incus config set instances.lxcfs.per_instance=true")

                              server.succeed(f"incus start {instance_name}")
                              server.wait_for_instance(instance_name)
                              server.succeed(f"pgrep -a lxcfs | grep 'incus/devices/{instance_name}/lxcfs'")
                    ''

                #
                # virtual-machine specific
                #
                +
                  lib.optionalString (config.type == "virtual-machine")
                    # python
                    ''
                      with subtest("[${image_id}] memory limits can be managed"):
                          server.set_instance_config(instance_name, "limits.memory 384MB", restart=True)
                          lsmem = json.loads(server.instance_succeed(instance_name, "lsmem --json"))
                          memsize = lsmem["memory"][0]["size"]
                          assert memsize == "384M", f"failed to manage memory limit. {memsize} != 384M"

                      with subtest("[${image_id}] incus-agent is started"):
                          server.succeed(f"incus exec {instance_name} systemctl is-active incus-agent")
                    ''

                +
                  #
                  # finalize
                  #
                  # python
                  ''
                    # this will leave the instances stopped
                    with subtest("[${image_id}] stop with incus-startup.service"):
                        pid = server.succeed(f"incus info {instance_name} | grep 'PID'").split(":")[1].strip()
                        server.succeed(f"ps {pid}")
                        server.succeed("systemctl stop incus-startup.service")
                        server.wait_until_fails(f"ps {pid}", timeout=120)
                        server.succeed("systemctl start incus-startup.service")

                  '';

              };
          }
        )
      );
      description = "";
      default = { };
    };

    appArmor = lib.mkEnableOption "AppArmor during tests";

    feature.user = lib.mkEnableOption "Validate incus user access feature";

    network.ovs = lib.mkEnableOption "Validate OVS network integration";

    storage = {
      lvm = lib.mkEnableOption "Validate LVM storage integration";
      zfs = lib.mkEnableOption "Validate ZFS storage integration";
    };
  };

  config = {
    tests.incus = { };
  };
}
