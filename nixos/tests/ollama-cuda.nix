{ lib, ... }:
{
  name = "ollama-cuda";
  meta.maintainers = with lib.maintainers; [ abysssol ];

  nodes.cuda =
    { ... }:
    {
      services.ollama.enable = true;
      services.ollama.acceleration = "cuda";
    };

  testScript = ''
    cuda.wait_for_unit("multi-user.target")
    cuda.wait_for_open_port(11434)
  '';
}
