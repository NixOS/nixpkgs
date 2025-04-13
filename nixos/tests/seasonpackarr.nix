{ lib, ... }:
{
  name = "seasonpackarr";
  meta.maintainers = with lib.maintainers; [ ambroisie ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.seasonpackarr = {
        enable = true;
        settings = {
          apiToken = {
            # Use an actual secret manager in production
            _secret = pkgs.writeText "apiToken" "someSecretTokenValue";
          };
        };
      };
    };

  testScript = # python
    ''
      start_all()
      machine.wait_for_unit("seasonpackarr.service")
      machine.wait_for_open_port(42069)

      with subtest("Test security"):
          output = machine.succeed("systemd-analyze security seasonpackarr.service")
          machine.log(output)
          assert output[-7:-1] == "OK :-)"
    '';
}
