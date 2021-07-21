import ./make-test-python.nix ({ pkgs, lib, ...}:
let pskFile = pkgs.writeText "psk-secrets" "nc-proxy:oaP4EishaeSaishei6rio6xeeph3az";
in {
  nodes = {
    server = {
      services.stunnel.enable = true;
      services.stunnel.servers."nc-server" =
        { accept = "/tmp/nc.sock";
          connect = "localhost:4002";
          ciphers = "PSK";
          PSKsecrets = pskFile;
        };
      services.stunnel.clients."nc-server" =
        { accept = "localhost:4001";
          connect = "/tmp/nc.sock";
          ciphers = "PSK";
          PSKsecrets = pskFile;
        };
    };
  };

  testScript = ''
    server.wait_for_unit("stunnel.service")
    server.execute("nc -l 4002 &")
    with subtest("stunnel set up with PSK works correctly"):
      server.succeed("nc localhost 4001 -z")
  '';
  maintainers = with lib.maintainers; [ dminuoso ];
})
