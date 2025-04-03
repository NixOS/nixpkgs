{ lib, ... }:
{
  name = "paretosecurity";
  meta.maintainers = [ lib.maintainers.zupo ];

  nodes.terminal =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      # Create a patched version of the package that points to the local dashboard
      # for easier testing
      patchedPareto = pkgs.paretosecurity.overrideAttrs (oldAttrs: {
        postPatch = ''
          substituteInPlace team/report.go \
            --replace-warn 'const reportURL = "https://dash.paretosecurity.com"' \
                           'const reportURL = "http://dashboard"'
        '';
      });
    in
    {
      imports = [ ./common/user-account.nix ];

      services.paretosecurity = {
        enable = true;
        package = patchedPareto;
      };

    };

  nodes.dashboard =
    { config, pkgs, ... }:
    {
      networking.firewall.allowedTCPPorts = [ 80 ];

      services.nginx = {
        enable = true;
        virtualHosts."dashboard" = {
          locations."/api/v1/team/".extraConfig = ''
            add_header Content-Type application/json;
            return 200 '{"message": "Linked device."}';
          '';
        };
      };
    };

  nodes.xfce =
    { config, pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      services.paretosecurity = {
        enable = true;
        trayIcon = true;
      };

      services.xserver.enable = true;
      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.desktopManager.xfce.enable = true;

      services.displayManager.autoLogin = {
        enable = true;
        user = "alice";
      };

      environment.systemPackages = [ pkgs.xdotool ];
      environment.variables.XAUTHORITY = "/home/alice/.Xauthority";

    };

  enableOCR = true;

  testScript = ''
    # Test setup
    terminal.succeed("su - alice -c 'mkdir -p /home/alice/.config'")
    for m in [terminal, dashboard]:
      m.systemctl("start network-online.target")
      m.wait_for_unit("network-online.target")

    # Test 1: Test the systemd socket is installed & enabled
    terminal.succeed('systemctl is-enabled paretosecurity.socket')

    # Test 2: Test running checks
    terminal.succeed(
      "su - alice -c 'paretosecurity check"
      # Disable some checks that need intricate test setup so that this test
      # remains simple and fast. Tests for all checks and edge cases available
      # at https://github.com/ParetoSecurity/agent/tree/main/test/integration
      + " --skip c96524f2-850b-4bb9-abc7-517051b6c14e"  # SecureBoot
      + " --skip 37dee029-605b-4aab-96b9-5438e5aa44d8"  # Screen lock
      + " --skip 21830a4e-84f1-48fe-9c5b-beab436b2cdb"  # Disk encryption
      + " --skip 44e4754a-0b42-4964-9cc2-b88b2023cb1e"  # Pareto Security is up to date
      + " --skip f962c423-fdf5-428a-a57a-827abc9b253e"  # Password manager installed
      + " --skip 2e46c89a-5461-4865-a92e-3b799c12034a"  # Firewall is enabled
      + "'"
    )

    # Test 3: Test linking
    terminal.succeed("su - alice -c 'paretosecurity link"
    + " paretosecurity://enrollTeam/?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9."
    + "eyJ0b2tlbiI6ImR1bW15LXRva2VuIiwidGVhbUlEIjoiZHVtbXktdGVhbS1pZCIsImlhdCI6"
    + "MTcwMDAwMDAwMCwiZXhwIjoxOTAwMDAwMDAwfQ.WgnL6_S0EBJHwF1wEVUG8GtIcoVvK5IjWbZpUeZr4Qw'")

    config = terminal.succeed("cat /home/alice/.config/pareto.toml")
    assert 'AuthToken = "dummy-token"' in config
    assert 'TeamID = "dummy-team-id"' in config

    # Test 4: Test the tray icon
    xfce.wait_for_x()
    for unit in [
        'paretosecurity-trayicon',
        'paretosecurity-user',
        'paretosecurity-user.timer'
    ]:
        status, out = xfce.systemctl("is-enabled " + unit, "alice")
        assert status == 0, f"Unit {unit} is not enabled (status: {status}): {out}"
    xfce.succeed("xdotool mousemove 850 10")
    xfce.wait_for_text("Pareto Security")
    xfce.succeed("xdotool click 1")
    xfce.wait_for_text("Run Checks")
  '';
}
