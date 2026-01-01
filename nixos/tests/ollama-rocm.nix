<<<<<<< HEAD
{ lib, pkgs, ... }:
=======
{ lib, ... }:
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
{
  name = "ollama-rocm";
  meta.maintainers = with lib.maintainers; [ abysssol ];

  nodes.rocm =
    { ... }:
    {
      services.ollama.enable = true;
<<<<<<< HEAD
      services.ollama.package = pkgs.ollama-rocm;
=======
      services.ollama.acceleration = "rocm";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

  testScript = ''
    rocm.wait_for_unit("multi-user.target")
    rocm.wait_for_open_port(11434)
  '';
}
