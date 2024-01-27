{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let common_meta = { maintainers = [ maintainers.viraptor ]; };
in
{
  gemstash_works = makeTest {
    name = "gemstash-works";
    meta = common_meta;

    nodes.machine = { config, pkgs, ... }: {
      services.gemstash = {
        enable = true;
      };
    };

    # gemstash responds to http requests
    testScript = ''
      machine.wait_for_unit("gemstash.service")
      machine.wait_for_file("/var/lib/gemstash")
      machine.wait_for_open_port(9292)
      machine.succeed("curl http://localhost:9292")
    '';
  };

  gemstash_custom_port = makeTest {
    name = "gemstash-custom-port";
    meta = common_meta;

    nodes.machine = { config, pkgs, ... }: {
      services.gemstash = {
        enable = true;
        openFirewall = true;
        settings = {
          bind = "tcp://0.0.0.0:12345";
        };
      };
    };

    # gemstash responds to http requests
    testScript = ''
      machine.wait_for_unit("gemstash.service")
      machine.wait_for_file("/var/lib/gemstash")
      machine.wait_for_open_port(12345)
      machine.succeed("curl http://localhost:12345")
    '';
  };
}
