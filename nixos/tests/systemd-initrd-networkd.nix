import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "systemd-initrd-network";
  meta.maintainers = [ lib.maintainers.elvishjerricco ];

  nodes = let
    mkFlushTest = flush: script: { ... }: {
      boot.initrd.systemd.enable = true;
      boot.initrd.network = {
        enable = true;
        flushBeforeStage2 = flush;
      };
      systemd.services.check-flush = {
        requiredBy = ["multi-user.target"];
        before = ["network-pre.target" "multi-user.target"];
        wants = ["network-pre.target"];
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        path = [ pkgs.iproute2 pkgs.iputils pkgs.gnugrep ];
        inherit script;
      };
    };
  in {
    basic = { ... }: {
      boot.initrd.network.enable = true;

      boot.initrd.systemd = {
        enable = true;
        # Enable network-online to fail the test in case of timeout
        network.wait-online.timeout = 10;
        network.wait-online.anyInterface = true;
        targets.network-online.requiredBy = [ "initrd.target" ];
        services.systemd-networkd-wait-online.requiredBy =
          [ "network-online.target" ];

          initrdBin = [ pkgs.iproute2 pkgs.iputils pkgs.gnugrep ];
          services.check = {
            requiredBy = [ "initrd.target" ];
            before = [ "initrd.target" ];
            after = [ "network-online.target" ];
            serviceConfig.Type = "oneshot";
            path = [ pkgs.iproute2 pkgs.iputils pkgs.gnugrep ];
            script = ''
              ip addr | grep 10.0.2.15 || exit 1
              ping -c1 10.0.2.2 || exit 1
            '';
          };
      };
    };

    doFlush = mkFlushTest true ''
      if ip addr | grep 10.0.2.15; then
        echo "Network configuration survived switch-root; flushBeforeStage2 failed"
        exit 1
      fi
    '';

    dontFlush = mkFlushTest false ''
      if ! (ip addr | grep 10.0.2.15); then
        echo "Network configuration didn't survive switch-root"
        exit 1
      fi
    '';
  };

  testScript = ''
    start_all()
    basic.wait_for_unit("multi-user.target")
    doFlush.wait_for_unit("multi-user.target")
    dontFlush.wait_for_unit("multi-user.target")
    # Make sure the systemd-network user was set correctly in initrd
    basic.succeed("[ $(stat -c '%U,%G' /run/systemd/netif/links) = systemd-network,systemd-network ]")
    basic.succeed("ip addr show >&2")
    basic.succeed("ip route show >&2")
  '';
})
