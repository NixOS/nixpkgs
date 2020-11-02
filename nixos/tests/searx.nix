import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "searx";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    services.searx = {
      enable = true;
      environmentFile = pkgs.writeText "secrets" ''
        WOLFRAM_API_KEY  = sometoken
        SEARX_SECRET_KEY = somesecret
      '';

      settings.server =
        { port = 8080;
          bind_address = "0.0.0.0";
          secret_key = "@SEARX_SECRET_KEY@";
        };

      settings.engines = {
        wolframalpha =
          { api_key = "@WOLFRAM_API_KEY@";
            engine = "wolframalpha_api";
          };
        startpage.shortcut = "start";
      };

    };
  };

  testScript =
    ''
      start_all()

      with subtest("Settings have been merged"):
          machine.wait_for_unit("searx")
          output = machine.succeed(
              "${pkgs.yq-go}/bin/yq r /var/lib/searx/settings.yml"
              " 'engines.(name==startpage).shortcut'"
          ).strip()
          assert output == "start", "Settings not merged"

      with subtest("Environment variables have been substituted"):
          machine.succeed("grep -q somesecret /var/lib/searx/settings.yml")
          machine.succeed("grep -q sometoken /var/lib/searx/settings.yml")

      with subtest("Searx service is running"):
          machine.wait_for_open_port(8080)
          machine.succeed(
              "${pkgs.curl}/bin/curl --fail http://localhost:8080"
          )

      machine.copy_from_vm("/var/lib/searx/settings.yml")
      machine.shutdown()
    '';
})

