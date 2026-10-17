{ pkgs, ... }:

{
  name = "ifm";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ litchipi ];
  };

  nodes = {
    server =
      { config, ... }:
      {
        services.ifm = {
          enable = true;
          port = 9001;
          dataDir = "/data";
        };

        systemd.tmpfiles.settings = {
          ifm-data-dir = {
            ${config.services.ifm.dataDir}.d = {
              mode = "0777";
              user = "root";
              group = "root";
            };
          };
        };
      };
  };

  testScript =
    # python
    ''
      start_all()
      server.wait_for_unit("ifm.service")
      server.wait_for_open_port(9001)
      server.succeed("curl --fail http://localhost:9001")

      server.succeed('echo "testfile" > testfile')
      server.succeed("shasum testfile | tee checksums")

      server.succeed('curl --fail http://localhost:9001 -X POST -F "api=upload" -F "dir=" -F "file=@testfile" | grep "OK"');
      server.succeed("rm testfile")

      server.succeed('curl --fail http://localhost:9001 -X POST -F "api=download" -F "filename=testfile" -F "dir=" --output testfile');
      server.succeed("shasum --check checksums")
    '';
}
