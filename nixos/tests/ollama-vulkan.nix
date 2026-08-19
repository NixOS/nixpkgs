{ lib, pkgs, ... }:
{
  name = "ollama-vulkan";
  meta.maintainers = [ ];

  nodes.vulkan =
    { ... }:
    {
      services.ollama.enable = true;
      services.ollama.package = pkgs.ollama-vulkan;
    };

  testScript = ''
    vulkan.wait_for_unit("multi-user.target")
    vulkan.wait_for_open_port(11434)
  '';
}
