{ pkgs, lib, ... }:

let
  port = 1080;
  uploadDir = "/var/lib/tusd/data";
in
{
  name = "tusd";
  meta.maintainers = with lib.maintainers; [
    m1-s
    nh2
    kalbasit
  ];

  nodes = {
    client = {
      environment.systemPackages = [ pkgs.curl ];
    };

    server = {
      services.tusd = {
        enable = true;
        inherit port uploadDir;
        openFirewall = true;
      };
    };
  };

  testScript = ''
    server.wait_for_unit("tusd.service")
    server.wait_for_open_port(${toString port})

    # Create large file.
    client.succeed("${pkgs.coreutils}/bin/truncate --size=100M file-100M.bin")

    # Upload it.
    client.wait_for_unit("network.target")
    client.succeed("${./tus-curl-upload.sh} file-100M.bin http://server:${toString port}/files/")

    # Verify file was created in uploadDir
    server.succeed("test -n \"$(ls -A ${uploadDir})\"")

    print("Upload succeeded")
  '';
}
