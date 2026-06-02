{
  lib,
  pkgs,
  ...
}:
let
  python = pkgs.python3.withPackages (
    ps: with ps; [
      requests
      playwright
      openpyxl
    ]
  );

  runScript = "${lib.getExe python} ${./basic_interaction_test.py}";

  run-goupile-test = pkgs.writeShellScriptBin "run-goupile-test" ''
    set -euo pipefail

    export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
    export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

    # check if attached to a terminal
    if [ -t 1 ]; then
      # interactive testing
      export HEADFUL=''${HEADFUL:-1}
      export PWDEBUG=''${PWDEBUG:-0}
      export DISPLAY=''${DISPLAY:-:0}
      if [ "$(id -u)" = "0" ] && [ -d "/home/alice" ]; then
        runuser -u alice \
          -w DISPLAY,HEADFUL,PWDEBUG,PLAYWRIGHT_BROWSERS_PATH,PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD \
          -- ${runScript}
      else
        ${runScript}
      fi
    else
      # non-interactive nixos test

      # Print instructions to the nix logs
      cat <<'EOF' | tee >(systemd-cat -t goupile-e2e)
    ================================================================================
    NOTE: The goupile e2e test can be run interactively either inside the vm or on the host
      - First, run `nix-build -A nixosTests.goupile.driverInteractive` and `./result/bin/nixos-test-driver`
      - Run `start_all()` inside the repl
      - Then `$(nix-build -A nixosTests.goupile.interactive-script)/bin/run-goupile-test` to run the full test interactively
      - Or `env PWDEBUG=1 $(nix-build -A nixosTests.goupile.interactive-script)/bin/run-goupile-test` to show the playwright inspector to debug
    ================================================================================
    EOF

      echo "Starting smoke test..." | systemd-cat -t goupile-e2e
      ${runScript} 2>&1 | tee >(systemd-cat -t goupile-e2e)
    fi
  '';
in
{
  name = "goupile";

  passthru.interactive-script = run-goupile-test;

  nodes.machine =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      services.goupile = {
        enable = true;
        enableSandbox = true;
        settings.HTTP.Port = 8889;
      };
      #systemd.services.goupile.environment.DEFAULT_SECCOMP_ACTION = "Log"; # Block|Log|Kill
      networking = {
        firewall.allowedTCPPorts = [ config.services.nginx.defaultHTTPListenPort ];
        domain = "local";
      };

      # goupile tries to resolve it at runtime, resolve it instead of patching it out
      # as the dns resolution step serves a purpose, to force glibc to load NSS libraries
      # see server/goupile.cc and search for getaddrinfo or www.example.com
      networking.extraHosts = ''
        127.0.0.1 www.example.com
      '';

      environment.systemPackages = [
        python
        run-goupile-test
      ];

      # more cores and memory to improve chromium performance
      virtualisation.memorySize = lib.mkForce 8192;
      virtualisation.cores = 4;
    };

  testScript =
    { nodes, ... }:
    let
      port = builtins.toString nodes.machine.services.goupile.settings.HTTP.Port;
    in
    # py
    ''
      import os
      start_all()

      machine.wait_for_unit("goupile.service")
      machine.wait_for_open_port(${port})

      machine.succeed("curl -q http://localhost:${port}")
      machine.succeed("curl -q http://machine.local")
      machine.succeed("curl -q http://localhost")

      try:
          machine.succeed("run-goupile-test")
      finally:
          out_dir = os.environ.get("out", os.getcwd())
          machine.copy_from_vm("/tmp/videos", out_dir)
    '';

  # Debug interactively with:
  # - nix-build -A nixosTests.goupile.driverInteractive
  # - ./result/bin/nixos-test-driver
  # - run_tests()
  # ssh -o User=root vsock%3 (can also do vsock/3, but % works with scp etc.)
  interactive.sshBackdoor.enable = true;

  interactive.nodes.machine =
    { config, ... }:
    let
      port = config.services.goupile.settings.HTTP.Port;
    in
    {
      imports = [
        # enable graphical session + users (alice, bob)
        ../../common/x11.nix
        ../../common/user-account.nix
      ];
      services.xserver.enable = true;
      test-support.displayManager.auto.user = "alice";

      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = port;
          guest.port = port;
        }
      ];

      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = [ port ];
    };

  meta.maintainers = lib.teams.ngi.members;
}
