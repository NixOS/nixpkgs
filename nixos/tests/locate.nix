import ./make-test-python.nix ({ lib, pkgs, ... }:
  let inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
  in {
    name = "locate";
    meta.maintainers = with pkgs.stdenv.lib.maintainers; [ chkno ];

    nodes = rec {
      a = {
        services.locate = {
          enable = true;
          interval = "*:*:0/5";
        };
      };
    };

    testScript = ''
      a.succeed("touch /file-on-a-machine-1")
      a.wait_for_file("/var/cache/locatedb")
      a.wait_until_succeeds("locate file-on-a-machine-1")
    '';
  })
