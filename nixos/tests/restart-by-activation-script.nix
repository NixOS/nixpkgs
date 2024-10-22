import ./make-test-python.nix ({ pkgs, ...} : {
  name = "restart-by-activation-script";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ das_j ];
  };

  nodes.machine = { pkgs, ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    system.switch.enable = true;

    systemd.services.restart-me = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/true";
      };
    };

    systemd.services.reload-me = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = rec {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/true";
        ExecReload = ExecStart;
      };
    };

    system.activationScripts.test = {
      supportsDryActivation = true;
      text = ''
        if [ -e /test-the-activation-script ]; then
          if [ "$NIXOS_ACTION" != dry-activate ]; then
            touch /activation-was-run
            echo restart-me.service > /run/nixos/activation-restart-list
            echo reload-me.service > /run/nixos/activation-reload-list
          else
            echo restart-me.service > /run/nixos/dry-activation-restart-list
            echo reload-me.service > /run/nixos/dry-activation-reload-list
          fi
        fi
      '';
    };
  };

  testScript = /* python */ ''
    machine.wait_for_unit("multi-user.target")

    with subtest("nothing happens when the activation script does nothing"):
        out = machine.succeed("/run/current-system/bin/switch-to-configuration dry-activate 2>&1")
        assert 'restart' not in out
        assert 'reload' not in out
        out = machine.succeed("/run/current-system/bin/switch-to-configuration test")
        assert 'restart' not in out
        assert 'reload' not in out

    machine.succeed("touch /test-the-activation-script")

    with subtest("dry activation"):
        out = machine.succeed("/run/current-system/bin/switch-to-configuration dry-activate 2>&1")
        assert 'would restart the following units: restart-me.service' in out
        assert 'would reload the following units: reload-me.service' in out
        machine.fail("test -f /run/nixos/dry-activation-restart-list")
        machine.fail("test -f /run/nixos/dry-activation-reload-list")

    with subtest("real activation"):
        out = machine.succeed("/run/current-system/bin/switch-to-configuration test 2>&1")
        assert 'restarting the following units: restart-me.service' in out
        assert 'reloading the following units: reload-me.service' in out
        machine.fail("test -f /run/nixos/activation-restart-list")
        machine.fail("test -f /run/nixos/activation-reload-list")
  '';
})
