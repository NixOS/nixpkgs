{ runTest }:
let
  meta = lib: { maintainers = with lib.maintainers; [ h7x4 ]; };

  commonQemuOptions = pkgs: [
    "-drive id=block1,if=none,format=raw,readonly=on,file=${pkgs.emptyFile}"
    "-drive id=block2,if=none,format=raw,readonly=on,file=${pkgs.emptyFile}"
    "-drive id=block3,if=none,format=raw,snapshot=on,file=${pkgs.emptyFile}"

    "-device nvme,drive=block1,serial=deadbeef"
    "-device nvme,drive=block2,serial=8badf00d"
    "-device ide-hd,drive=block3,serial=c0ffee"
  ];
in
{
  # NOTE: With `services.smartd.notifications.test = true`, smartd will send a test notification on every start.
  #       However, since smartd often starts up before the notification medium,
  #       we have to manually restart it in some of the tests after awaiting everything else to be ready.
  notifyX11 = runTest (
    { pkgs, lib, ... }:
    {
      name = "smartd-notify-x11";
      meta = meta lib;
      enableOCR = true;
      nodes.machine = {
        imports = [ ./common/x11.nix ];

        virtualisation.qemu.options = commonQemuOptions pkgs;

        services.smartd.enable = true;
        services.smartd.notifications.test = true;
        services.smartd.notifications.wall.enable = false;
        services.smartd.notifications.x11.enable = true;
      };

      testScript = ''
        machine.wait_for_x()
        machine.wait_for_unit("smartd.service")
        machine.systemctl("restart smartd.service")

        machine.wait_until_succeeds("${lib.getExe' pkgs.procps "ps"} -aux | grep xmessage | grep -v grep")
        machine.wait_for_text("(?i)test email from smartd for device")
      '';
    }
  );

  notifyWall = runTest (
    { pkgs, lib, ... }:
    {
      name = "smartd-notify-wall";
      meta = meta lib;
      enableOCR = true;
      nodes.machine = {
        imports = [ ./common/user-account.nix ];

        virtualisation.qemu.options = commonQemuOptions pkgs;

        services.getty.autologinUser = "alice";

        services.smartd.enable = true;
        services.smartd.notifications.test = true;
        services.smartd.notifications.wall.enable = true;
      };

      testScript = ''
        machine.wait_for_unit("smartd.service")
        machine.wait_for_unit("user@1000.service")

        machine.systemctl("restart smartd.service")
        machine.wait_for_text("(?i)test email from smartd for device")
      '';
    }
  );

  notifyMail = runTest (
    { pkgs, lib, ... }:
    {
      name = "smartd-notify-mail";
      meta = meta lib;
      nodes.machine = {
        virtualisation.qemu.options = commonQemuOptions pkgs;

        services.smartd.enable = true;
        services.smartd.notifications.test = true;
        services.smartd.notifications.wall.enable = false;
        services.smartd.notifications.mail = {
          enable = true;
          sender = "smartd@example.org";
          recipient = "admin@example.org";
          mailer = pkgs.writeShellScript "fake-sendmail" ''
            ${pkgs.coreutils}/bin/cat > /tmp/smartd-mail.out
          '';
        };

        systemd.services.smartd.serviceConfig = {
          PrivateTmp = lib.mkForce false;
          ReadWritePaths = [ "/tmp" ];
        };
      };

      testScript = ''
        machine.wait_for_unit("smartd.service")
        machine.wait_for_file("/tmp/smartd-mail.out")
        machine.succeed("grep -q 'TEST EMAIL from smartd for device:' /tmp/smartd-mail.out")
      '';
    }
  );

  notifySystembus = runTest (
    { pkgs, lib, ... }:
    {
      name = "smartd-notify-systembus";
      meta = meta lib;
      nodes.machine = {
        virtualisation.qemu.options = commonQemuOptions pkgs;

        services.smartd.enable = true;
        services.smartd.notifications.test = true;
        services.smartd.notifications.wall.enable = false;
        services.smartd.notifications.systembus-notify.enable = true;
      };

      testScript = ''
        machine.wait_for_unit("dbus.service")
        machine.wait_for_unit("smartd.service")

        machine.execute(
            "${lib.getExe' pkgs.dbus "dbus-monitor"} --system"
            " \"interface='net.nuetzlich.SystemNotifications',member='Notify'\""
            " > /tmp/dbus-monitor.out 2>&1 &"
        )
        machine.wait_until_succeeds("pgrep -f dbus-monitor")
        machine.systemctl("restart smartd.service")
        machine.wait_until_succeeds("grep -q 'TEST EMAIL from smartd for device:' /tmp/dbus-monitor.out")
      '';
    }
  );

  autoDetect = runTest (
    { lib, ... }:
    {
      name = "smartd-autodetect";
      meta = meta lib;
      nodes.machine =
        { pkgs, lib, ... }:
        {
          virtualisation.qemu.options = commonQemuOptions pkgs;

          services.smartd.enable = true;
        };

      testScript = ''
        machine.wait_for_unit("smartd.service")
        machine.wait_for_console_text(r'Device: /dev/sda \[SAT\], is SMART capable. Adding to "monitor" list')
        machine.wait_for_console_text('Device: /dev/nvme0, is SMART capable. Adding to "monitor" list')
        machine.wait_for_console_text('Device: /dev/nvme1, is SMART capable. Adding to "monitor" list')
      '';
    }
  );

  manuallyMonitored = runTest (
    { lib, ... }:
    {
      name = "smartd-autodetect";
      meta = meta lib;
      nodes.machine =
        { pkgs, lib, ... }:
        {
          virtualisation.qemu.options = commonQemuOptions pkgs;

          services.smartd.enable = true;
          services.smartd.devices = [
            {
              device = "/dev/nvme1";
            }
          ];
          services.smartd.autodetect = false;
        };

      testScript = ''
        machine.wait_for_unit("smartd.service")
        machine.wait_for_console_text('Device: /dev/nvme1, is SMART capable. Adding to "monitor" list')
        machine.wait_for_console_text('Started S.M.A.R.T. Daemon')

        machine.succeed("journalctl -eu smartd.service --grep /dev/nvme1")
        machine.fail("journalctl -eu smartd.service --grep /dev/nvme0")
        machine.fail("journalctl -eu smartd.service --grep /dev/sda")
      '';
    }
  );

  saveState = runTest (
    { lib, ... }:
    {
      name = "smartd-savestate";
      meta = meta lib;
      nodes.machine =
        { pkgs, lib, ... }:
        {
          virtualisation.qemu.options = commonQemuOptions pkgs;

          services.smartd.enable = true;
          services.smartd.extraOptions = [ "--savestates=/var/lib/smartd/ --interval=10" ];
        };

      testScript = ''
        machine.wait_for_unit("smartd.service")
        machine.systemctl("stop smartd.service")
        machine.succeed("test -f /var/lib/smartd/QEMU_NVMe_Ctrl-deadbeef.nvme.state")
        machine.succeed("test -f /var/lib/smartd/QEMU_NVMe_Ctrl-8badf00d.nvme.state")
        machine.succeed("test -f /var/lib/smartd/QEMU_HARDDISK-c0ffee.ata.state")
      '';
    }
  );
}
