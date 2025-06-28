{
  pkgs,
  version,
}:
pkgs.testers.runNixOSTest {
  name = "pulsemeeter-version";

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.pulseaudio.enable = true;
      services.pulseaudio.systemWide = true;
      users.users.alice = {
        isNormalUser = true;
        password = "foo";
        extraGroups = [
          "wheel"
          "pulse-access"
        ];
        packages = with pkgs; [
          pulsemeeter
        ];
      };
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("su -- root -c 'systemctl start pulseaudio'")
    machine.succeed("su -- alice -c 'mkdir -p /home/alice/.config/pulsemeeter'")
    version = machine.execute("su -- alice -c 'pulsemeeter -s | head -n 4 | tail -n 1'")
    assert version == (0, 'Pulsemeeter version: \x1b[1m${version}\x1b[0m\n')
  '';
}
