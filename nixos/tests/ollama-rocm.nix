{ lib, ... }:
{
  name = "ollama-rocm";
  meta.maintainers = with lib.maintainers; [ abysssol ];

  nodes.rocm =
    { ... }:
    {
      services.ollama.enable = true;
      services.ollama.acceleration = "rocm";
    };

  testScript = ''
    rocm.wait_for_unit("multi-user.target")
    rocm.wait_for_open_port(11434)
  '';
}
