{ pkgs, ... }:
{
  name = "clashtui";

  nodes.machine = {
    environment.systemPackages = [ pkgs.curl ];

    users.users.alice = {
      isNormalUser = true;
      group = "users";
    };

    services.clashtui = {
      enable = true;
      enableMihomo = true;
      enableSingbox = true;
      defaultCore = "none";
      users = [ "alice" ];
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    machine.succeed("clashtui --version")
    machine.succeed("mihomo -v")
    machine.succeed("sing-box version")

    machine.fail("systemctl is-active --quiet clashtui_mihomo.service")
    machine.fail("systemctl is-active --quiet clashtui_singbox.service")

    machine.succeed("""
      set +e
      sudo -u alice env CLASHTUI_CONFIG_DIR=/home/alice/.config/clashtui timeout 5 clashtui >/dev/null 2>&1
      status=$?
      # Upstream currently exits with 134 without a TTY, after initializing the config directory.
      test "$status" = 0 -o "$status" = 124 -o "$status" = 134
    """)
    machine.succeed("test -s /home/alice/.config/clashtui/config.yaml")
    machine.succeed("test -s /home/alice/.config/clashtui/mihomo/core_override_config.yaml")
    machine.succeed("test -s /home/alice/.config/clashtui/sing-box/core_override_config.json")
    machine.succeed("test -d /home/alice/.config/clashtui/mihomo/templates")
    machine.succeed("test -d /home/alice/.config/clashtui/sing-box/templates")
    machine.succeed("test -d /home/alice/.config/clashtui/mihomo/profiles")
    machine.succeed("test -d /home/alice/.config/clashtui/sing-box/profiles")
    machine.succeed("test -s /home/alice/.config/clashtui/clashtui.db")
    machine.succeed("grep -q 'mihomo:' /home/alice/.config/clashtui/config.yaml")
    machine.succeed("grep -q 'singbox:' /home/alice/.config/clashtui/config.yaml")

    machine.succeed("systemctl start clashtui-init.service")
    machine.succeed("systemctl is-active --quiet clashtui-init.service")

    machine.succeed("test -f /opt/clashtui/mihomo/config/config.yaml")
    machine.succeed("test -f /opt/clashtui/sing-box/config/config.json")
    machine.succeed("test -L /opt/clashtui/mihomo/mihomo")
    machine.succeed("test -L /opt/clashtui/sing-box/sing-box")
    machine.succeed("test -x /opt/clashtui/mihomo/mihomo")
    machine.succeed("test -x /opt/clashtui/sing-box/sing-box")

    machine.succeed("grep -q 'mixed-port: 7890' /opt/clashtui/mihomo/config/config.yaml")
    machine.succeed("grep -q 'external_controller' /opt/clashtui/sing-box/config/config.json")
    machine.succeed("test \"$(stat -c '%U:%G:%a' /opt/clashtui/mihomo/config/config.yaml)\" = mihomo:mihomo:660")
    machine.succeed("test \"$(stat -c '%U:%G:%a' /opt/clashtui/sing-box/config/config.json)\" = sing-box:sing-box:660")
    machine.succeed("test \"$(stat -c '%U:%G:%a' /opt/clashtui/mihomo/config)\" = mihomo:mihomo:2775")
    machine.succeed("test \"$(stat -c '%U:%G:%a' /opt/clashtui/sing-box/config)\" = sing-box:sing-box:2775")

    machine.succeed("id -nG alice | grep -w mihomo")
    machine.succeed("id -nG alice | grep -w sing-box")
    machine.succeed("sudo -u alice test -r /opt/clashtui/mihomo/config/config.yaml")
    machine.succeed("sudo -u alice test -r /opt/clashtui/sing-box/config/config.json")

    machine.succeed("mihomo -t -d /opt/clashtui/mihomo/config")
    machine.succeed("sing-box check -D /opt/clashtui/sing-box/config -c /opt/clashtui/sing-box/config/config.json")

    machine.succeed("systemctl start clashtui_mihomo.service")
    machine.wait_for_unit("clashtui_mihomo.service")
    machine.wait_for_open_port(7890)
    machine.wait_for_open_port(9090)
    machine.succeed("curl --fail --max-time 10 --proxy http://localhost:7890 http://localhost:9090")
    machine.succeed("systemctl stop clashtui_mihomo.service")

    machine.succeed("systemctl start clashtui_singbox.service")
    machine.wait_for_unit("clashtui_singbox.service")
    machine.wait_for_open_port(2080)
    machine.wait_for_open_port(9090)
  '';
}
