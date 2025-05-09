import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "cmk-agent-nixos";
    meta.maintainers = with pkgs.lib.maintainers; [
      cobalt
      weriomat
    ];
    nodes.server =
      { config, ... }:
      {
        services.cmk-agent.enable = true;
        environment.systemPackages = [ config.services.cmk-agent.package ];
      };
    testScript = ''
      start_all()
      assert "inoperational" not in server.succeed("cmk-agent-ctl status")
      server.succeed("cmk-agent-ctl dump")
    '';
  }
)
