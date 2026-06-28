{ lib, ... }:
{
  name = "spotify-ad-muter";

  meta.maintainers = with lib.maintainers; [ luna5akura ];

  nodes.machine =
    { pkgs, ... }:
    {
      users.users.alice = {
        isNormalUser = true;
        linger = true;
        uid = 1000;
      };

      services.spotify-ad-muter.enable = true;

      environment.systemPackages = [ pkgs.spotify-ad-muter ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("default.target", "alice")

    with subtest("user service is installed"):
        machine.succeed("test -e /etc/systemd/user/spotify-ad-muter.service")
        machine.succeed("grep -F 'SPOTIFY_AD_MUTER_RESUME_DELAY=2' /etc/systemd/user/spotify-ad-muter.service")
        machine.succeed("grep -F 'SPOTIFY_AD_MUTER_COMMAND_TIMEOUT=2' /etc/systemd/user/spotify-ad-muter.service")

    with subtest("restore command is executable"):
        machine.succeed("sudo -u alice XDG_RUNTIME_DIR=/run/user/1000 spotify-ad-muter --restore")
  '';
}
