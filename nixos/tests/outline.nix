{ lib, ... }:
{
  name = "outline";

  meta.maintainers = with lib.maintainers; [
    e1mo
    xanderio
  ];

  node.pkgsReadOnly = false;

  nodes.outline = {
    virtualisation.memorySize = 2 * 1024;
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
