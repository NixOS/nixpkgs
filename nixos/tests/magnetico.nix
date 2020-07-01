import ./make-test-python.nix ({ pkgs, ...} :

let
  port = 8081;
in
{
  name = "magnetico";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    networking.firewall.allowedTCPPorts = [ 9000 ];

    services.magnetico = {
      enable = true;
      crawler.port = 9000;
      web.port = port;
      web.credentials.user = "$2y$12$P88ZF6soFthiiAeXnz64aOWDsY3Dw7Yw8fZ6GtiqFNjknD70zDmNe";
    };
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("magneticod")
      machine.wait_for_unit("magneticow")
      machine.succeed(
          "${pkgs.curl}/bin/curl "
          + "-u user:password http://localhost:${toString port}"
      )
      assert "Unauthorised." in machine.succeed(
          "${pkgs.curl}/bin/curl "
          + "-u user:wrongpwd http://localhost:${toString port}"
      )
      machine.shutdown()
    '';
})
