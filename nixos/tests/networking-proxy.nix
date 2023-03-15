# Test whether `networking.proxy' work as expected.

# TODO: use a real proxy node and put this test into networking.nix
# TODO: test whether nix tools work as expected behind a proxy

let default-config = {
        imports = [ ./common/user-account.nix ];

        services.xserver.enable = false;

      };
in import ./make-test-python.nix ({ pkgs, ...} : {
  name = "networking-proxy";
  meta = with pkgs.lib.maintainers; {
    maintainers = [  ];
  };

  nodes = {
    # no proxy
    machine =
      { ... }:

      default-config;

    # proxy default
    machine2 =
      { ... }:

      default-config // {
        networking.proxy.default = "http://user:pass@host:port";
      };

    # specific proxy options
    machine3 =
      { ... }:

      default-config //
      {
        networking.proxy = {
          # useless because overridden by the next options
          default = "http://user:pass@host:port";
          # advanced proxy setup
          httpProxy = "123-http://user:pass@http-host:port";
          httpsProxy = "456-http://user:pass@https-host:port";
          rsyncProxy = "789-http://user:pass@rsync-host:port";
          ftpProxy = "101112-http://user:pass@ftp-host:port";
          noProxy = "131415-127.0.0.1,localhost,.localdomain";
        };
      };

    # mix default + proxy options
    machine4 =
      { ... }:

      default-config // {
        networking.proxy = {
          # open for all *_proxy env var
          default = "000-http://user:pass@default-host:port";
          # except for those 2
          rsyncProxy = "123-http://user:pass@http-host:port";
          noProxy = "131415-127.0.0.1,localhost,.localdomain";
        };
      };
    };

  testScript =
    ''
      from typing import Dict, Optional


      def get_machine_env(machine: Machine, user: Optional[str] = None) -> Dict[str, str]:
          """
          Gets the environment from a given machine, and returns it as a
          dictionary in the form:
              {"lowercase_var_name": "value"}

          Duplicate environment variables with the same name
          (e.g. "foo" and "FOO") are handled in an undefined manner.
          """
          if user is not None:
              env = machine.succeed("su - {} -c 'env -0'".format(user))
          else:
              env = machine.succeed("env -0")
          ret = {}
          for line in env.split("\0"):
              if "=" not in line:
                  continue

              key, val = line.split("=", 1)
              ret[key.lower()] = val
          return ret


      start_all()

      with subtest("no proxy"):
          assert "proxy" not in machine.succeed("env").lower()
          assert "proxy" not in machine.succeed("su - alice -c env").lower()

      with subtest("default proxy"):
          assert "proxy" in machine2.succeed("env").lower()
          assert "proxy" in machine2.succeed("su - alice -c env").lower()

      with subtest("explicitly-set proxy"):
          env = get_machine_env(machine3)
          assert "123" in env["http_proxy"]
          assert "456" in env["https_proxy"]
          assert "789" in env["rsync_proxy"]
          assert "101112" in env["ftp_proxy"]
          assert "131415" in env["no_proxy"]

          env = get_machine_env(machine3, "alice")
          assert "123" in env["http_proxy"]
          assert "456" in env["https_proxy"]
          assert "789" in env["rsync_proxy"]
          assert "101112" in env["ftp_proxy"]
          assert "131415" in env["no_proxy"]

      with subtest("default proxy + some other specifics"):
          env = get_machine_env(machine4)
          assert "000" in env["http_proxy"]
          assert "000" in env["https_proxy"]
          assert "123" in env["rsync_proxy"]
          assert "000" in env["ftp_proxy"]
          assert "131415" in env["no_proxy"]

          env = get_machine_env(machine4, "alice")
          assert "000" in env["http_proxy"]
          assert "000" in env["https_proxy"]
          assert "123" in env["rsync_proxy"]
          assert "000" in env["ftp_proxy"]
          assert "131415" in env["no_proxy"]
    '';
})
