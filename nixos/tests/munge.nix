{ lib, ... }:
{
  name = "munge";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      services.munge.enable = true;
    };

  testScript =
    { nodes }:
    let
      aliceUid = toString nodes.machine.users.users.alice.uid;
    in
    ''
      machine.succeed("mkdir -p /etc/munge && echo '${lib.strings.replicate 5 "hunter2"}' > /etc/munge/munge.key && chown munge: /etc/munge/munge.key")
      machine.systemctl("restart munged.service")
      machine.wait_for_unit("munged.service")

      machine.succeed("sudo -u bob -- munge -u ${aliceUid} -s 'top secret' -o ./secret.txt")
      machine.succeed("grep -v 'top secret' ./secret.txt")
      machine.succeed("sudo -u alice unmunge -i ./secret.txt | grep 'top secret'")
    '';
}
