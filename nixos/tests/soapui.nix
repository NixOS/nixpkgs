{ pkgs, ... }:
{
  name = "soapui";
  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [
        ./common/x11.nix
      ];

      services.xserver.enable = true;

      environment.systemPackages = [ pkgs.soapui ];
    };

  testScript = ''
    machine.wait_for_x()
    machine.succeed("soapui >&2 &")
    machine.wait_for_window(r"SoapUI \d+\.\d+\.\d+")
    machine.sleep(1)
    machine.screenshot("soapui")
  '';
}
