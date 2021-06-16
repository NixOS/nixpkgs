import ./make-test-python.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "libinput";
  meta.maintainers = with pkgs.lib.maintainers; [ thiagokokada ];

  machine = { ... }:
    {
      imports = [
        ./common/x11.nix
        ./common/user-account.nix
      ];

      test-support.displayManager.auto.user = "alice";

      services.xserver.libinput = {
        enable = true;
        mouse = {
          accelProfile = "flat";
          accelSpeed = -0.5;
        };
      };
    };

  testScript = ''
    def expect_xserver_option(option, value):
        machine.succeed(f"""cat /var/log/X.0.log | grep 'Option "{option}" "{value}"'""")


    machine.start()
    machine.wait_for_x()
    machine.succeed("cat /var/log/X.0.log | grep libinput")

    expect_xserver_option("AccelProfile", "flat")
    expect_xserver_option("AccelSpeed", "-0.5")
    expect_xserver_option("NaturalScrolling", "off")
    expect_xserver_option("HorizontalScrolling", "on")
  '';
})
