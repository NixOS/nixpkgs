{ lib, ... }:
{
  name = "ipget";
  meta.maintainers = with lib.maintainers; [
    Luflosi
  ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.kubo.enable = true;
      environment.systemPackages = with pkgs; [ ipget ];
    };

  testScript = ''
    start_all()

    with subtest("Add file to IPFS"):
        ipfs_hash = machine.succeed(
            "echo -n fnord | ipfs add --quieter"
        )

    with subtest("Download the file with ipget"):
        machine.succeed(f"ipget --output file.txt /ipfs/{ipfs_hash}")
        contents = machine.succeed("cat file.txt")
        assert contents == "fnord", f"Unexpected file contents: {contents}"
  '';
}
