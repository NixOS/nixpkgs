{ lib, ... }:
{
  name = "systemd-lock-handler";

  meta.maintainers = with lib.maintainers; [ liff ];

  enableOCR = true;

  nodes.machine =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      touch = "${lib.getBin pkgs.coreutils}/bin/touch";
    in
    {
      imports = [ common/wayland-cage.nix ];

      services.systemd-lock-handler.enable = true;

      systemd.user.services = {
        test-lock = {
          partOf = [ "lock.target" ];
          onSuccess = [ "unlock.target" ];
          before = [ "lock.target" ];
          wantedBy = [ "lock.target" ];
          serviceConfig.ExecStart = "${touch} /tmp/lock.target.activated";
        };
        test-unlock = {
          partOf = [ "unlock.target" ];
          after = [ "unlock.target" ];
          wantedBy = [ "unlock.target" ];
          serviceConfig.ExecStart = "${touch} /tmp/unlock.target.activated";
        };
        test-sleep = {
          partOf = [ "sleep.target" ];
          before = [ "sleep.target" ];
          wantedBy = [ "sleep.target" ];
          serviceConfig.ExecStart = "${touch} /tmp/sleep.target.activated";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit('graphical.target')
    machine.wait_for_text('alice@machine')

    machine.send_chars('loginctl lock-session\n')
    machine.wait_for_file('/tmp/lock.target.activated')
    machine.wait_for_file('/tmp/unlock.target.activated')

    machine.send_chars('systemctl suspend\n')
    # wait_for_file won’t complete before the machine is asleep,
    # so we’ll watch the log instead.
    machine.wait_for_console_text('Started test-sleep.service.')

    # The VM is asleep, regular shutdown won’t work.
    machine.crash()
  '';
}
