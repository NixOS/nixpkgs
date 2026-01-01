<<<<<<< HEAD
{ lib, pkgs, ... }:
=======
{ lib, ... }:
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
{
  name = "ollama-vulkan";
  meta.maintainers = with lib.maintainers; [ abysssol ];

  nodes.vulkan =
    { ... }:
    {
      services.ollama.enable = true;
<<<<<<< HEAD
      services.ollama.package = pkgs.ollama-vulkan;
=======
      services.ollama.acceleration = "vulkan";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

  testScript = ''
    vulkan.wait_for_unit("multi-user.target")
    vulkan.wait_for_open_port(11434)
  '';
}
