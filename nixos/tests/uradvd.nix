{ pkgs, ... }:
{
  name = "uradvd";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ aiyion ];
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.uradvd ];
    };

  testScript = ''
    machine.wait_for_unit("default.target")

    with subtest("help text does not report unexpected features"):
        expected_help_text = ("Usage: uradvd [-h] -i <interface> -a/-p <prefix> [ -a/-p <prefix> ... ]\n"
                              "[ --default-lifetime <seconds> ] [ --rdnss <ip> ... ]\n"
                              "[ --valid-lifetime <seconds> ] [ --preferred-lifetime <seconds> ]\n"
                              "[ --max-router-adv-interval <seconds> ] [ --min-router-adv-interval <seconds> ]\n"
                             )
        print(expected_help_text)
        actual_help_text = machine.succeed("uradvd -h 2>&1")
        assert actual_help_text == expected_help_text

    with subtest("uradvd fails without mandatory arguments"):
        machine.fail("uradvd")

    with subtest("uradvd launches"):
        machine.succeed("uradvd -i eth1 -p 2001:db8:1::/64 >&2 &")
  '';
}
