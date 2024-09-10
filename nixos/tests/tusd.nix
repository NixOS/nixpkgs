import ./make-test-python.nix ({pkgs, lib, ...}:

let
  port = 1080;

  client = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.curl ];
  };

  server = { pkgs, ... }: {
    # tusd does not have a NixOS service yet.
    systemd.services.tusd = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''${pkgs.tusd}/bin/tusd -port "${toString port}" -upload-dir=/data'';
      };
    };
    networking.firewall.allowedTCPPorts = [ port ];
  };
in {
  name = "tusd";

  nodes = {
    inherit server;
    inherit client;
  };

  testScript = ''
    server.wait_for_unit("tusd.service")

    # Create large file.
    client.succeed("${pkgs.coreutils}/bin/truncate --size=100M file-100M.bin")

    # Upload it.
    client.succeed("${./tus-curl-upload.sh} file-100M.bin http://server:${toString port}/files/")

    print("Upload succeeded")
  '';
})
