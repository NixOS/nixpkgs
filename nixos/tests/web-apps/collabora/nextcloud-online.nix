{
  lib,
  pkgs,
  ...
}:
let
  hostname = "localhost";
  nextcloudPort = 8180;
  collaboraPort = 9980;

  python = pkgs.python3.withPackages (
    p: with p; [
      playwright
      openpyxl
    ]
  );

  run-collabora-test = pkgs.writeShellScriptBin "run-collabora-test" ''
    set -euo pipefail

    export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
    export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

    # check if attached to a terminal
    if [ -t 1 ]; then
      # interactive testing
      export HEADFUL=''${HEADFUL:-1}
      export PWDEBUG=''${PWDEBUG:-0}

      if [ "$(id -u)" = "0" ] && [ -d "/home/alice" ]; then
        exec su alice -c "env DISPLAY=:0 \
          HEADFUL=$HEADFUL \
          PWDEBUG=$PWDEBUG \
          PLAYWRIGHT_BROWSERS_PATH=$PLAYWRIGHT_BROWSERS_PATH \
          PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 \
          ${lib.getExe python} ${./basic_interaction_test.py}"
      else
        exec ${lib.getExe python} ${./basic_interaction_test.py}
      fi
    else
      # non-interactive nixos test

      # Print instructions to the nix logs
      cat <<'EOF' | tee >(systemd-cat -t collabora-e2e-test)
    ================================================================================
    NOTE: The collabora e2e test can be run either inside the vm or on the host
      - First, run `nix run .#nixosTests.collabora.driverInteractive -L` and `start_all()` inside the repl
      - Then `nix run .#nixosTests.collabora.interactive-script` to run the full test interactively
      - Or `env PWDEBUG=1 nix run .#nixosTests.collabora.interactive-script` to show the playwright inspector to debug
    ================================================================================
    EOF

      echo "Starting e2e test..." | systemd-cat -t collabora-e2e-test
      ${lib.getExe python} ${./basic_interaction_test.py} 2>&1 | tee >(systemd-cat -t collabora-e2e)
    fi
  '';

in
{
  name = "Collabora online nextcloud integration test";

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.nextcloud = {
        enable = true;
        hostName = hostname;
        config.adminpassFile = "/etc/nextcloud-admin-pass";
        config.dbtype = "sqlite";
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps) richdocuments;
        };
      };
      services.nginx.defaultHTTPListenPort = nextcloudPort;
      # WARNING: use proper secret management scheme in a production configuration
      # See https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes
      environment.etc."nextcloud-admin-pass".text = "a";

      services.collabora-online = {
        enable = true;
        port = collaboraPort;
        settings = {
          ssl.enable = false;
          ssl.termination = false;
          logging.level = "trace";
        };
        aliasGroups = [ { host = "http://${hostname}:${toString nextcloudPort}"; } ];
      };

      systemd.services.nextcloud-setup-collabora = {
        after = [ "nextcloud-setup.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ config.services.nextcloud.occ ];
        serviceConfig = {
          Type = "oneshot";
          User = "nextcloud";
        };
        script = ''
          nextcloud-occ config:app:set richdocuments disable_certificate_verification --value yes
          nextcloud-occ richdocuments:setup --wopi-url=http://${hostname}:${toString collaboraPort}
        '';
      };

      networking.firewall.enable = false;
      environment.systemPackages = [
        python
        run-collabora-test
      ];

      # more cores and memory to improve collabora-online performance
      virtualisation.memorySize = lib.mkForce 8192;
      virtualisation.cores = 4;
    };

  testScript = /* py */ ''
    import os
    start_all()
    machine.wait_for_open_port(8180)
    machine.wait_for_open_port(9980)
    machine.wait_for_unit("multi-user.target")

    machine.wait_for_console_text("fpm is running")

    print(machine.succeed("run-collabora-test"))
    out_dir = os.environ.get("out", os.getcwd())
    machine.copy_from_vm("/tmp/videos", out_dir)
  '';

  passthru.interactive-script = run-collabora-test;

  # Debug interactively with:
  # - nix run .#nixosTests.collabora.driverInteractive -L
  # - run_tests()
  # ssh -o User=root vsock%3 (can also do vsock/3, but % works with scp etc.)
  interactive.sshBackdoor.enable = true;

  interactive.nodes.machine =
    { lib, ... }:
    {
      imports = [
        ../../common/x11.nix
        ../../common/user-account.nix
      ];
      services.xserver.enable = true;
      test-support.displayManager.auto.user = "alice";

      virtualisation.forwardPorts = [
        {
          from = "host";
          guest.port = nextcloudPort;
          host.port = nextcloudPort;
        }
        {
          from = "host";
          guest.port = collaboraPort;
          host.port = collaboraPort;
        }
      ];
    };

  meta.maintainers = with lib.maintainers; [ xzfc ] ++ lib.teams.ngi.members;
}
