{ config, lib, moduleType, hostPkgs, ... }:
let
  inherit (lib) mkOption mkDefault types mdDoc concatStringsSep mapAttrsToList;
  inherit (builtins) toString attrNames;
  finalNodes = config.interactive.driver.nodes;

  # allow accessing machines through a jumphost whose ssh port is forwarded to from the host
  sshConfig = hostPkgs.writeText "ssh-config" ''
    Host *
      User root
      StrictHostKeyChecking no
      BatchMode yes
      ConnectTimeout 20
      UserKnownHostsFile=/dev/null
      LogLevel Error # no "added to known hosts"
    Host redeploy_jumphost
      HostName localhost
      Port ${
        let
          fwds = config.interactive.nodes.redeploy_jumphost.virtualisation.forwardPorts;
          sshFwds = builtins.filter (fwd: fwd.guest.port == 22) fwds;
          sshFwd = builtins.head sshFwds;
        in
          toString sshFwd.host.port
        }
    Host * !redeploy_jumphost
      ProxyJump redeploy_jumphost
  '';

  redeploy = hostPkgs.writeShellScriptBin "redeploy" ''
    # create an association array from machine names to the path to their
    # configuration in the nix store
    declare -A configPaths=(${
      concatStringsSep " "
        (mapAttrsToList
          (n: v: ''["${n}"]="${v.system.build.toplevel}"'')
          finalNodes)
    })

    redeploy_one() {
      machine="$1"
      echo "pushing new config to '$machine'"

      if [ -z ''${configPaths[$machine]+x} ]; then
        echo "No machine '$machine' in this test."
        exit 1
      fi

      if ! ssh -F ${sshConfig} $machine true; then
        echo "Couldn't connect to '$machine'. Make sure you've started it with "'`'"$machine.start()"'`'" in the test interactive driver."
        echo "Problems could also arise if you have modified openssh settings or set a root password."
        exit 1
      fi

      # taken from nixos-rebuild (we only want to do the activate part)
       cmd=(
          "systemd-run"
          "-E" "LOCALE_ARCHIVE"
          "--collect"
          "--no-ask-password"
          "--pty"
          "--quiet"
          "--same-dir"
          "--service-type=exec"
          "--unit=nixos-rebuild-switch-to-configuration"
          "--wait"
          "''${configPaths[$machine]}/bin/switch-to-configuration"
          "test"
      )


      if ! ssh -F ${sshConfig} $machine "''${cmd[@]}"; then
          echo "warning: error(s) occurred while switching to the new configuration"
          exit 1
      fi
    }

    # TODO: is there a way to automatically start redeploy_jumphost?
    if ! ssh -F ${sshConfig} redeploy_jumphost true; then
      echo "Couldn't connect to the jump host. Make sure you are running driverInteractive, and that you've run "'`'"redeploy_jumphost.start()"'`'""
      exit 1
    fi

    machines="$@"

    # if there are no machines specified, assume all of them
    if [ -z "$machines" ]; then
      machines="${concatStringsSep " " (attrNames finalNodes)}"
    fi

    for machine in $machines; do
      redeploy_one $machine
    done
  '';
in
{
  options = {
    interactive = mkOption {
      description = mdDoc ''
        Tests [can be run interactively](#sec-running-nixos-tests-interactively)
        using the program in the test derivation's `.driverInteractive` attribute.

        When they are, the configuration will include anything set in this submodule.

        You can set any top-level test option here.

        Example test module:

        ```nix
        { config, lib, ... }: {

          nodes.rabbitmq = {
            services.rabbitmq.enable = true;
          };

          # When running interactively ...
          interactive.nodes.rabbitmq = {
            # ... enable the web ui.
            services.rabbitmq.managementPlugin.enable = true;
          };
        }
        ```

        For details, see the section about [running tests interactively](#sec-running-nixos-tests-interactively).
      '';
      type = moduleType;
      visible = "shallow";
    };
  };

  config = {
    interactive.qemu.package = hostPkgs.qemu;
    interactive.extraDriverArgs = [ "--interactive" ];

    # allow access to all machines via ssh
    # TODO: this will not work if anyone changes a password. we could instead put redeploy_jumphost's ssh public key as authorized on all the machines
    # SEE: https://serverfault.com/questions/337274/ssh-from-a-through-b-to-c-using-private-key-on-b
    interactive.defaults = {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PermitEmptyPasswords = "yes";
          UsePAM = "no";
        };
      };
    };

    # jump host so there is one standard VM to forward a port to
    # TODO: is there a way to automatically start redeploy_jumphost?
    interactive.nodes.redeploy_jumphost = {
      virtualisation = {
        # there's a tradeoff here. people are likely to be confused by a machine
        # starting up that they don't recognize. on the other hand, hiding it
        # causes confusion if anything goes wrong. i'm chosing to hide it.
        qemu.options = [ "-nographic" ];
        forwardPorts = mkDefault [{
          from = "host";
          host.port = 2222;
          guest.port = 22;
        }];
      };
    };

    passthru = {
      # can `nix run .#test.redeploy` or `nix build .#test.driverInteractive && run ./result/bin/redeploy`
      # also `ssh -F ./result/ssh-config <machine>`
      inherit redeploy sshConfig;
      driverInteractive = config.interactive.driver.overrideAttrs (old: {
        # comes from runCommand, not mkDerivation, so this is the entrypoint
        buildCommand = old.buildCommand + ''
          ln -s ${sshConfig} $out/ssh-config
          ln -s ${redeploy}/bin/redeploy $out/bin/redeploy
        '';
      });
    };

  };
}
