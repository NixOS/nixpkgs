# Test whether `networking.proxy' work as expected.

# TODO: use a real proxy node and put this test into networking.nix
# TODO: test whether nix tools work as expected behind a proxy

let default-config = {
        imports = [ ./common/user-account.nix ];

        services.xserver.enable = false;

        virtualisation.memorySize = 128;
      };
in import ./make-test.nix ({ pkgs, ...} : {
  name = "networking-proxy";
  meta = with pkgs.stdenv.lib.maintainers; {
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
          # useless because overriden by the next options
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
      startAll;

      # no proxy at all
      print $machine->execute("env | grep -i proxy");
      print $machine->execute("su - alice -c 'env | grep -i proxy'");
      $machine->mustFail("env | grep -i proxy");
      $machine->mustFail("su - alice -c 'env | grep -i proxy'");

      # Use a default proxy option
      print $machine2->execute("env | grep -i proxy");
      print $machine2->execute("su - alice -c 'env | grep -i proxy'");
      $machine2->mustSucceed("env | grep -i proxy");
      $machine2->mustSucceed("su - alice -c 'env | grep -i proxy'");

      # explicitly set each proxy option
      print $machine3->execute("env | grep -i proxy");
      print $machine3->execute("su - alice -c 'env | grep -i proxy'");
      $machine3->mustSucceed("env | grep -i http_proxy | grep 123");
      $machine3->mustSucceed("env | grep -i https_proxy | grep 456");
      $machine3->mustSucceed("env | grep -i rsync_proxy | grep 789");
      $machine3->mustSucceed("env | grep -i ftp_proxy | grep 101112");
      $machine3->mustSucceed("env | grep -i no_proxy | grep 131415");
      $machine3->mustSucceed("su - alice -c 'env | grep -i http_proxy | grep 123'");
      $machine3->mustSucceed("su - alice -c 'env | grep -i https_proxy | grep 456'");
      $machine3->mustSucceed("su - alice -c 'env | grep -i rsync_proxy | grep 789'");
      $machine3->mustSucceed("su - alice -c 'env | grep -i ftp_proxy | grep 101112'");
      $machine3->mustSucceed("su - alice -c 'env | grep -i no_proxy | grep 131415'");

      # set default proxy option + some other specifics
      print $machine4->execute("env | grep -i proxy");
      print $machine4->execute("su - alice -c 'env | grep -i proxy'");
      $machine4->mustSucceed("env | grep -i http_proxy | grep 000");
      $machine4->mustSucceed("env | grep -i https_proxy | grep 000");
      $machine4->mustSucceed("env | grep -i rsync_proxy | grep 123");
      $machine4->mustSucceed("env | grep -i ftp_proxy | grep 000");
      $machine4->mustSucceed("env | grep -i no_proxy | grep 131415");
      $machine4->mustSucceed("su - alice -c 'env | grep -i http_proxy | grep 000'");
      $machine4->mustSucceed("su - alice -c 'env | grep -i https_proxy | grep 000'");
      $machine4->mustSucceed("su - alice -c 'env | grep -i rsync_proxy | grep 123'");
      $machine4->mustSucceed("su - alice -c 'env | grep -i ftp_proxy | grep 000'");
      $machine4->mustSucceed("su - alice -c 'env | grep -i no_proxy | grep 131415'");
    '';
})
