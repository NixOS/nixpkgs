let
  initialContainer = extra: import <nixpkgs/nixos/lib/eval-config.nix> {
    modules = [
      ({...}: {
        config = {
          boot.isContainer = true;
          networking.useDHCP = false;
          networking.hostName = "test-container";
        };
      })
    ] ++ extra;
  };
in import ./make-test-python.nix ({ pkgs, ... }: {
  name = "systemd-config-reload";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ ma27 ];

  nodes = let
    baseCfg = extra: { ... }: {
      systemd.services."systemd-nspawn@test-container".preStart = ''
        mkdir -p /var/lib/machines/test-container/{var,etc}
        [ -e "/var/lib/machines/test-container/etc/os-release" ] || \
          touch /var/lib/machines/test-container/etc/{os-release,machine-id} || true
      '';
      systemd.nspawn.test-container = {
        execConfig = {
          Boot = false;
          Parameters = "${(initialContainer extra).config.system.build.toplevel}/init";
          KillSignal = "SIGRTMIN+3";
        };
        filesConfig = {
          BindReadOnly = [ "/nix/store" "/nix/var/nix/db" "/nix/var/nix/daemon-socket" ];
        };
      };
    };
  in {
    base = baseCfg [];
    configUpdate = baseCfg [
      ({ pkgs, ... }: {
        environment.systemPackages = [ pkgs.hello ];
      })
    ];
    removed = { ... }: {
    };
    reloadScriptForContainer = { ... }: let
      extra = ({ pkgs, ... }: {
        environment.systemPackages = [ pkgs.hello ];
      });
    in {
      imports = [
        (baseCfg [
          extra
        ])
      ];
      systemd.nspawn.test-container.reloadOnChange = true;
      systemd.nspawn.test-container.restartOnChange = false;
      systemd.services."systemd-nspawn@test-container".serviceConfig.ExecReload = "${pkgs.writeScriptBin "activate" ''
        #! ${pkgs.runtimeShell} -xe
        systemd-run --machine test-container --pty --quiet -- /bin/sh --login -c \
          '${(initialContainer [extra]).config.system.build.toplevel}/bin/switch-to-configuration test'
      ''}/bin/activate";
    };
  };

  testScript = { nodes, ... }: let
    modified = nodes.configUpdate.config.system.build.toplevel;
    removed = nodes.removed.config.system.build.toplevel;
    reload = nodes.reloadScriptForContainer.config.system.build.toplevel;
  in ''
    base.start()
    base.wait_for_unit("systemd-nspawn@test-container.service")
    assert "test-container" in base.succeed("machinectl")

    base.wait_until_succeeds(
        "systemd-run --machine test-container --pty --quiet -- /bin/sh -c 'echo container shell is accessible' >&2"
    )

    base.fail(
        "systemd-run --machine test-container --pty --quiet -- /bin/sh -c '/run/current-system/sw/bin/hello' >&2"
    )

    out = base.succeed(
        "${modified}/bin/switch-to-configuration test 2>&1 | tee /dev/stderr"
    )

    assert (
        "restarting the following units: network-addresses-eth1.service, systemd-nspawn@test-container.service"
        in out
    )

    base.succeed("machinectl show test-container")
    base.wait_until_succeeds(
        "systemd-run --machine test-container --pty --quiet -- /bin/sh -c '/run/current-system/sw/bin/hello' >&2"
    )

    base.succeed(
        "${removed}/bin/switch-to-configuration test 2>&1 | tee /dev/stderr"
    )

    base.fail("machinectl show test-container")

    out = base.succeed(
        "${modified}/bin/switch-to-configuration test 2>&1 | tee /dev/stderr"
    )

    assert (
        "starting the following units: nscd.service, systemd-nspawn@test-container.service"
        in out
    )

    base.require_unit_state("systemd-nspawn@test-container", "active")

    assert "test-container" in base.succeed("machinectl")
    base.wait_until_succeeds(
        "systemd-run --machine test-container --pty --quiet -- /bin/sh -c 'echo container shell is accessible' >&2"
    )

    base.require_unit_state("systemd-nspawn@test-container", "active")

    out = base.succeed(
        "${reload}/bin/switch-to-configuration test 2>&1 | tee /dev/stderr"
    )
    assert (
        "restarting the following units: network-addresses-eth1.service, systemd-nspawn@test-container.service"
        not in out
    )
    assert "systemd-nspawn@test-container.service is not active, cannot reload." not in out
    base.require_unit_state("systemd-nspawn@test-container", "active")
    base.wait_until_succeeds(
        "systemd-run --machine test-container --pty --quiet -- /bin/sh -c 'echo container shell is accessible' >&2"
    )

    base.wait_until_succeeds(
        "systemd-run --machine test-container --pty --quiet -- /bin/sh -c '/run/current-system/sw/bin/hello' >&2"
    )

    base.shutdown()
  '';
})
