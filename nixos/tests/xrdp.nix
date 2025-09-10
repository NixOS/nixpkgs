{ pkgs, ... }:
{
  name = "xrdp";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    server =
      { pkgs, ... }:
      {
        imports = [ ./common/user-account.nix ];
        services.xrdp.enable = true;
        services.xrdp.defaultWindowManager = "${pkgs.xterm}/bin/xterm";
        networking.firewall.allowedTCPPorts = [ 3389 ];
      };

    client =
      { pkgs, ... }:
      {
        imports = [
          ./common/x11.nix
          ./common/user-account.nix
        ];
        test-support.displayManager.auto.user = "alice";
        environment.systemPackages = [ pkgs.freerdp ];
        services.xrdp.enable = true;
        services.xrdp.defaultWindowManager = "${pkgs.icewm}/bin/icewm";
      };
  };

  testScript =
    { nodes, ... }:
    let
      user = nodes.client.users.users.alice;
    in
    ''
      start_all()

      client.wait_for_x()
      client.wait_for_file("${user.home}/.Xauthority")
      client.succeed("xauth merge ${user.home}/.Xauthority")

      client.sleep(5)

      client.execute("xterm >&2 &")
      client.sleep(1)
      client.send_chars("xfreerdp /cert-tofu /w:640 /h:480 /v:127.0.0.1 /u:${user.name} /p:${user.password}\n")
      client.sleep(5)
      client.screenshot("localrdp")

      client.execute("xterm >&2 &")
      client.sleep(1)
      client.send_chars("xfreerdp /cert-tofu /w:640 /h:480 /v:server /u:${user.name} /p:${user.password}\n")
      client.sleep(5)
      client.screenshot("remoterdp")
    '';
}
