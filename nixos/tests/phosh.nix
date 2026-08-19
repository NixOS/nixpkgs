{ pkgs, ... }:
let
  pin = "1234";
in
{
  name = "phosh";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ zhaofengli ];
  };

  nodes = {
    phone =
      { config, pkgs, ... }:
      {
        users.users.nixos = {
          isNormalUser = true;
          password = pin;
        };

        services.xserver.desktopManager.phosh = {
          enable = true;
          user = "nixos";
          group = "users";

          phocConfig = {
            outputs.Virtual-1 = {
              scale = 2;
            };
          };
        };

        environment.systemPackages = [
          pkgs.phosh-mobile-settings
        ];

        systemd.services.phosh = {
          environment = {
            # Accelerated graphics fail on phoc 0.20 (wlroots 0.15)
            "WLR_RENDERER" = "pixman";
          };
        };

        virtualisation.resolution = {
          x = 720;
          y = 1440;
        };
        virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci,xres=720,yres=1440" ];
      };
  };

  enableOCR = true;

  testScript = ''
    import time

    start_all()

    # Prevent the RTC from setting the time to an undesired value after we already set it to a different value
    phone.wait_for_file("/dev/rtc0")
    phone.succeed("hwclock --set --date '2022-01-01 07:00'")

    phone.wait_for_unit("phosh.service")

    with subtest("Check that we can see the lock screen info page"):
        # Saturday, January 1
        phone.succeed("date -s '2022-01-01 07:00'")

        phone.wait_for_text("Saturday")
        phone.screenshot("01lockinfo")

    with subtest("Check that we can unlock the screen"):
        phone.send_chars("${pin}", delay=0.2)
        time.sleep(1)
        phone.screenshot("02unlock")

        phone.send_chars("\n")

        phone.wait_for_text("All Apps")
        phone.screenshot("03launcher")

    with subtest("Check mobile-phosh-settings starts"):
       phone.send_chars("mobile setting", delay=0.2)
       phone.send_chars("\n")
       phone.wait_for_text("Tweak advanced mobile settings");
       phone.screenshot("04settings")
  '';
}
