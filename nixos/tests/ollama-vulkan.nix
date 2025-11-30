{ lib, ... }:
{
  name = "ollama-vulkan";
  meta.maintainers = with lib.maintainers; [ abysssol ];

  nodes.vulkan =
    { ... }:
    {
      services.ollama.enable = true;
      services.ollama.acceleration = "vulkan";
    };

  testScript = ''
    vulkan.wait_for_unit("multi-user.target")
    vulkan.wait_for_open_port(11434)
  '';
}
