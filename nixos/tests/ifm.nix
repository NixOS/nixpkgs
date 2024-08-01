import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "ifm";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ litchipi ];
  };

  nodes = {
    server = rec {
      services.ifm = {
        enable = true;
        port = 9001;
        dataDir = "/data";
      };

      system.activationScripts.ifm-setup-dir = ''
        mkdir -p ${services.ifm.dataDir}
        chmod u+w,g+w,o+w ${services.ifm.dataDir}
      '';
    };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("ifm.service")
    server.wait_for_open_port(9001)
    server.succeed("curl --fail http://localhost:9001")

    server.succeed("echo \"testfile\" > testfile && shasum testfile >> checksums")
    server.succeed("curl --fail http://localhost:9001 -X POST -F \"api=upload\" -F \"dir=\" -F \"file=@testfile\" | grep \"OK\"");
    server.succeed("rm testfile")
    server.succeed("curl --fail http://localhost:9001 -X POST -F \"api=download\" -F \"filename=testfile\" -F \"dir=\" --output testfile");
    server.succeed("shasum testfile >> checksums && shasum --check checksums")
  '';
})
