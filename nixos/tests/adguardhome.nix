{
  name = "adguardhome";

  nodes = {
    nullConf = { ... }: { services.adguardhome = { enable = true; }; };

    emptyConf = { lib, ... }: {
      services.adguardhome = {
        enable = true;
        settings = {};
      };
    };

    declarativeConf = { ... }: {
      services.adguardhome = {
        enable = true;

        mutableSettings = false;
        settings = {
          schema_version = 0;
          dns = {
            bind_host = "0.0.0.0";
            bootstrap_dns = "127.0.0.1";
          };
        };
      };
    };

    mixedConf = { ... }: {
      services.adguardhome = {
        enable = true;

        mutableSettings = true;
        settings = {
          schema_version = 0;
          dns = {
            bind_host = "0.0.0.0";
            bootstrap_dns = "127.0.0.1";
          };
        };
      };
    };
  };

  testScript = ''
    with subtest("Minimal (settings = null) config test"):
        nullConf.wait_for_unit("adguardhome.service")

    with subtest("Default config test"):
        emptyConf.wait_for_unit("adguardhome.service")
        emptyConf.wait_for_open_port(3000)

    with subtest("Declarative config test, DNS will be reachable"):
        declarativeConf.wait_for_unit("adguardhome.service")
        declarativeConf.wait_for_open_port(53)
        declarativeConf.wait_for_open_port(3000)

    with subtest("Mixed config test, check whether merging works"):
        mixedConf.wait_for_unit("adguardhome.service")
        mixedConf.wait_for_open_port(53)
        mixedConf.wait_for_open_port(3000)
        # Test whether merging works properly, even if nothing is changed
        mixedConf.systemctl("restart adguardhome.service")
        mixedConf.wait_for_unit("adguardhome.service")
        mixedConf.wait_for_open_port(3000)
  '';
}
