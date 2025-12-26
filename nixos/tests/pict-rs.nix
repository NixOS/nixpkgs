{ pkgs, lib, ... }:
{
  name = "pict-rs";
  meta.maintainers = with lib.maintainers; [ happysalada ];

  nodes.machine =
    { ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
        jq
      ];
      services.pict-rs.enable = true;
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("pict-rs")
    machine.wait_for_open_port(8080)
  '';
}
