{ lib, pkgs, ... }:
{
  name = "ollama-rocm";
  meta.maintainers = with lib.maintainers; [ abysssol ];

  nodes.rocm =
    { ... }:
    {
      services.ollama.enable = true;
      services.ollama.package = pkgs.ollama-rocm;
    };

  testScript = ''
    rocm.wait_for_unit("multi-user.target")
    rocm.wait_for_open_port(11434)
  '';
}
