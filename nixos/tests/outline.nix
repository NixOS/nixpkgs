{ lib, ... }:
{
  name = "outline";

  meta.maintainers = lib.teams.cyberus.members;

  node.pkgsReadOnly = false;

  nodes.outline = {
    virtualisation.memorySize = 2 * 1024;
    nixpkgs.config.allowUnfree = true;
    services.outline = {
      enable = true;
      forceHttps = false;
      storage = {
        storageType = "local";
      };
    };
  };

  testScript = ''
    outline.wait_for_unit("outline.service")
    outline.wait_for_open_port(3000)
    outline.succeed("curl --fail http://localhost:3000/")
  '';
}
