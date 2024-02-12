import ./make-test-python.nix ({ ... }:

{
  name = "libinput";

  nodes.machine = { ... }:
    {
      imports = [
        ./common/x11.nix
        ./common/user-account.nix
      ];

      test-support.displayManager.auto.user = "alice";

      services.xserver.libinput = {
        enable = true;
        mouse = {
          naturalScrolling = true;
          leftHanded = true;
          middleEmulation = false;
          horizontalScrolling = false;
        };
      };
    };

  testScript = ''
    def expect_xserver_option(option, value):
        machine.succeed(f"""cat /var/log/X.0.log | grep -F 'Option "{option}" "{value}"'""")

    machine.start()
    machine.wait_for_x()
    machine.succeed("""cat /var/log/X.0.log | grep -F "Using input driver 'libinput'" """)
    expect_xserver_option("NaturalScrolling", "on")
    expect_xserver_option("LeftHanded", "on")
    expect_xserver_option("MiddleEmulation", "off")
    expect_xserver_option("HorizontalScrolling", "off")
  '';
})
